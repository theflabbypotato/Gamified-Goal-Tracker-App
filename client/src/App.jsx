import { useEffect, useState } from 'react'
import axios from 'axios'
import './App.css'

function App() {
  const [skillName, setSkill] = useState('');
  const [selectedSkillId, setSelectedSkillId] = useState('');

  const [goalName, setGoal] = useState('');
  const [goalDescription, setDescription] = useState('');
  const [dailyMinutes, setMinutes] = useState('');
  const [completedToday, setCompletedToday] = useState([]); // array of goal ids that have been completed today

  const [goals, setAllGoals] = useState([]); // array of goal objects with all table info
  const [skills, setAllSkills] = useState([]); // array of skill objects

  const [currentTime, setCurrentTime] = useState(new Date());

  const [xpMap, setXpMap] = useState({}); // maps (skill id, amount of xp)

  const [showGoalModal, setShowGoalModal] = useState(false); // for the pop ups
  const [showSkillModal, setShowSkillModal] = useState(false);

  // react component, fires after the screen loads
  useEffect(() => {
    fetchSkills();
    fetchGoals(); // fetches goals
    fetchCompletedToday(); // fetches completed
    fetchXP();

    const interval = setInterval(() => {
      setCurrentTime(new Date()); // stops timer when component goes away so no memory leaks
    }, 1000);

    return () => clearInterval(interval);
  }, [])

  // gets all the skills
  const fetchSkills = async() => {
    try {
      const response = await axios.get('http://localhost:5050/skills');
      setAllSkills(response.data);
    } catch (error) {
      console.error('Error fetching skills', error);
    }
  }

  // gets all the goals, useful to refresh once a goal is added
  const fetchGoals = async() => {
    try {
      const response = await axios.get('http://localhost:5050/goals');
      setAllGoals(response.data); // calls the function to update the goals variable which then updates the list
    } catch (error) {
      console.error('Error fetching goals', error);
    }
  }

  // fetches an array of goal IDs that have been completed
  const fetchCompletedToday = async() => {
    try {
      const response = await axios.get('http://localhost:5050/logs/today');
      setCompletedToday(response.data); // array of goal IDs
    } catch (error) {
      console.error('Error fetching logs', error);
    }
  }

  // fetches the XP
  const fetchXP = async() => {
    try {
      const response = await axios.get('http://localhost:5050/xp')
      setXpMap(response.data);
    } catch (error) {
      console.error('error fetching xp', error);
    }
  }

  // for submitting skills:
  const handleSkillSubmit = async (e) => {
    e.preventDefault();
    
    try {
      console.log('Sending prompt to backend:', `A symbolic icon for the skill "${skillName}" in flat design`);
      const imgRes = await axios.post('http://localhost:5050/generate-image', {
        prompt: `A symbolic icon for the skill "${skillName}" in flat design` // uses name
        // `A symbolic icon for the skill ${skillName} in flat design` // uses name
      });

      const imageUrl = imgRes.data.imageUrl;

      const response = await axios.post('http://localhost:5050/skills', {
        name: skillName,
        imageUrl: imageUrl
      });
      
      // clears
      setSkill('');
      fetchSkills();
      setShowSkillModal(false);

      console.log('Skill created:', response.data);
    } catch (error) {
      console.error('Error creating skill', error);
    }
  }

  // for submitting goals, async allows await so app doesnt freeze while waiting for a response from server 
  const handleGoalSubmit = async (e) => {
    e.preventDefault();

    if (!selectedSkillId) {
      alert('Please select a skill!');
      return;
    }

    // try catches are super common for API calls, database operations
    try {
      // POST html request, updates data
      const response = await axios.post('http://localhost:5050/goals', {
        name: goalName,
        description: goalDescription,
        dailyMinutes: Number(dailyMinutes),
        skillId: Number(selectedSkillId)
      });
      console.log('Goal created:', response.data);
      // clears form, back to blank
      setGoal('');
      setDescription('');
      setMinutes('');
      setSelectedSkillId('');
      fetchGoals();
      setShowGoalModal(false);
    } catch (error) {
      console.error('Error creating goal', error);
    }
  }

  // deletes skill of designated ID
  const handleDeleteSkill = async (id) => {
    try {
      await axios.delete(`http://localhost:5050/skills/${id}`)
      fetchSkills();
    } catch (error) {
      console.error('Error deleting skill', error);
    }
  }

  // confirmation for deleting skill
  const confirmSkillDelete = (id) => {
    if (window.confirm("Are you sure you want to delete this skill?")) {
      handleDeleteSkill(id);
    }
  };

  // deletes goal of desginated ID
  const handleDeleteGoal = async (id) => {
    try {
      await axios.delete(`http://localhost:5050/goals/${id}`) // deletes
      fetchGoals();
    } catch (error) {
      console.error('Error deleting goal', error);
    }
  }

  // confirmation for deleting goal
  const confirmGoalDelete = (id) => {
    if (window.confirm("Are you sure you want to delete this goal?")) {
      handleDeleteGoal(id);
    }
  };

  // handles completion of check box/goal
  const handleGoalComplete = async (goalId) => {
    try {
      await axios.post('http://localhost:5050/logs', {goalId}) // sends this goal id
      fetchCompletedToday();
      fetchXP();
      console.log('Updated XP:', xpMap);
    } catch (error) {
      console.error('Error completing goal', error);
    }
  }

  // this describes the HTML
  return (
    <div className="App">
      <h1>Gamified Goal Tracker&nbsp;🎯</h1>
      <img
        src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExczZ6cnZ2Nnd3Ymp4ZjNsdWNhcHIybHI0eGRhbjNqZzk1c2txeWs0MCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3XB8e0uQUZrPvf7Egk/giphy.gif"
        alt="Dancing celebration"
        className="dancing-gif"
      />

      {/* Clock */}
      <div className="clock">
        <div>{currentTime.toLocaleString()}</div>
        <div>Daily Goals Reset at Midnight! (Refresh Page)</div>
      </div>

      {/* Rendering skills and add skill button */}
      <div style={{ display: "flex", alignItems: "center", gap: "10px"}}>
        <h2>Skills:</h2>
        <button onClick={() => setShowSkillModal(true)}>Add Skill</button>
      </div>
      <ul>
        {skills.map(skill => {
          const xp = xpMap[skill.id] || 0; // either 0 or the associated xp with the skill
          const level = Math.floor(xp / 200) + 1;
          const progressPercent = (xp % 200) / 2;

          return (
            <li key={skill.id} className="card" style={{ marginBottom: '20px' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '20px' }}>
                {/* Skill image */}
                {skill.image_url && (
                  <img
                    src={skill.image_url}
                    alt={skill.name}
                    style={{ width: '60px', height: '60px', borderRadius: '10px' }}
                  />
                )}

                {/* XP Bar */}
                <div style={{flex:1}}>

                  {/* Title + Delete Skill Button in a flex wrapper */}
                  <div style={{ display: "flex", alignItems: "center", gap: "10px"}}>
                    <h3>{skill.name}</h3>
                    <button
                      onClick={() => confirmSkillDelete(skill.id)} style={{ marginLeft: "10px" }}
                      className='delete-circle'
                      title='Delete'
                    >
                      ×
                    </button>
                  </div>

                  <p>
                    <span>Level: {level}</span>
                    <span style={{ marginLeft: '20px' }}>{xp % 200} / 200 XP to next level</span>
                  </p>
                  <div className="progress-container">
                    <div
                      className='progress-bar'
                      style={{
                        width: `${progressPercent}%`, // 2 XP = 1%
                        height: '20px',
                        backgroundColor: 'green',
                        borderRadius: '10px',
                      }}
                    ></div>
                  </div>
                  
                </div>
              </div>
            </li>
          );
        })}
      </ul>
  
      {/* Rendering goals and add goal button */}
      <div style={{ display: "flex", alignItems: "center", gap: "10px"}}>
        <h2>Goals:</h2>
        <button onClick={() => setShowGoalModal(true)}>Add Goal</button>
      </div>

      <ul>
        {goals.map(goal => {
          const isCompleted = completedToday.includes(goal.id); // all the ones that are completed, uses the variable

          return (
            <li key={goal.id} style={{marginBottom: '20px'}}>
              {/* if isCompleted is TRUE, then there is a line through */}

              <div style={{ display: "flex", alignItems: "center", gap: "10px"}}>
                <label style={{ textDecoration: isCompleted ? 'line-through': 'none'}}>
                  <input
                    type="checkbox"
                    checked={isCompleted}
                    onChange={() => handleGoalComplete(goal.id)} // calls this to POST to '/logs'
                    disabled={isCompleted}
                  />
                  {goal.name} - {goal.daily_minutes} minutes/day
                </label>
                {/* Delete button */}
                <button
                  onClick={() => confirmGoalDelete(goal.id)} style={{ marginLeft: "10px" }}
                  className='delete-circle'
                  title='Delete'
                >
                  ×
                </button>
              </div>              
            </li>
          );
        })}
      </ul>

      {/* Modal popup for adding skills*/}
      {/* Popup only appears when variable is set to true */}
      {showSkillModal && (
        <div className='modal-overlay'>
          <div className='modal'>
            <h2>Add a New Skill</h2>
            <form onSubmit={handleSkillSubmit}>
              <input
                type="text"
                placeholder='Skill Name'
                value={skillName}
                onChange={(e) => setSkill(e.target.value)}
              />
              <div style={{ marginTop: "1rem" }}>
                <button type="submit">Submit</button>
                <button
                  type="button"
                  onClick={() => {
                    setSkill('');
                    setShowSkillModal(false);
                  }}
                  style={{ marginLeft: "10px" }}
                >Cancel</button>
              </div>
            </form>
          </div>
        </div>

      )}

      {/* When user presses enter or clicks submit button, runs 'handleGoalSubmit', react event handler */}
      {showGoalModal && (
        <div className='modal-overlay'>
          <div className='modal'>
            <h2>Add a New Goal</h2>
            <form onSubmit={handleGoalSubmit}>
              <select value={selectedSkillId} onChange={(e) => setSelectedSkillId(e.target.value)}>
                <option value="">Select a Skill</option>
                {skills.map(skill => (
                  <option key={skill.id} value={skill.id}>{skill.name}</option>
                ))}
              </select>
              <input
                type="text" 
                placeholder='Goal Name'
                value={goalName}
                onChange={(e) => setGoal(e.target.value)}
              />
              <input
                type="text"
                placeholder='Goal Description'
                value={goalDescription}
                onChange={(e) => setDescription(e.target.value)}
              />
              <input
                type="number"
                placeholder='Daily Minutes'
                value={dailyMinutes}
                onChange={(e) => setMinutes(e.target.value)}
              />
              <div style={{ marginTop: "1rem" }}>
                <button type="submit">Submit</button>
                <button
                  type="button"
                  onClick={() => {
                    setGoal('');
                    setDescription('');
                    setMinutes('');
                    setSelectedSkillId('');
                    setShowGoalModal(false);
                  }}
                  style={{ marginLeft: "10px" }}
                >Cancel</button>
              </div>
            </form>
          </div>
        </div>
      )}


    </div>
  )
}

export default App
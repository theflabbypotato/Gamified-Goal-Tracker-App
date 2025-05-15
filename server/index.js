// initializes the express app

// importing modules
const express = require('express');
const cors = require('cors');
const app = express(); // instance of the express application
require('dotenv').config(); // loads environment variables from .env
const axios = require('axios');

const pool = require('./db'); // import db so that it connects with PostgreSQL

// Setting up Open AI
const USE_IMAGE_API = process.env.USE_IMAGE_API === 'true'; //switch for testing
const OpenAI = require('openai');
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

app.use(cors()); // so can make API calls 
app.use(express.json()); // parses

const PORT = 5050;

// ****************************** SKILLS ******************************
// POST request at /skills
app.post('/skills', async (req, res) => {
    const {name, imageUrl} = req.body;

    try {
        const newSkill = await pool.query(
            'INSERT INTO skills (name, image_url) VALUES ($1, $2) RETURNING *',
            [name, imageUrl]
        );
        console.log('Recieved new skill: ', name);
        res.json(newSkill.rows[0]); // send back inserted goal
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }

});

// Backend GET
app.get('/skills', async (req, res) => {
    try {
        const allSkills = await pool.query('SELECT * FROM skills ORDER BY id ASC');
        res.json(allSkills.rows);
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// Backend delete
app.delete('/skills/:id', async(req, res) => {
    const {id} = req.params;

    try {
        await pool.query('DELETE FROM goal_logs WHERE goal_id IN (SELECT id FROM goals WHERE skill_id = $1)', [id]) // delete associated logs

        await pool.query('DELETE FROM goals WHERE skill_id = $1', [id]) // delete associated skills

        await pool.query('DELETE FROM skills WHERE id = $1', [id]); // delete skill

        res.json({ message: "Skill and associated things deleted!" });
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// ****************************** GOALS ******************************
// POST request at /goals, adding new goals
app.post('/goals', async (req, res) => {
    const { name, description, dailyMinutes, skillId} = req.body; // get the values from the app

    try {
        const newGoal = await pool.query( // sends the Postgre query
            'INSERT INTO goals (name, description, daily_minutes, skill_id) VALUES ($1, $2, $3, $4) RETURNING *',
            [name, description, dailyMinutes, skillId]
        );
        console.log('Recieved new goal: ', name, description, dailyMinutes, skillId);
        res.json(newGoal.rows[0]); // send back inserted goal
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// Backend GET for displaying all goals
app.get('/goals', async (req, res) => {
    try {
        const allGoals = await pool.query('SELECT * FROM goals ORDER BY id ASC');
        res.json(allGoals.rows); // sends info to app
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// For deleting a goal by id
// Goals have ID's designated from how the tables were set up
app.delete('/goals/:id', async(req, res) => {
    const {id} = req.params;

    try {
        await pool.query('DELETE FROM goal_logs WHERE goal_id = $1', [id]); // deletes all the logs

        await pool.query('DELETE FROM goals WHERE id = $1', [id]); // deletes at ID

        res.json({ message: 'Goal deleted!'});
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// ****************************** LOGS ******************************
// For recording a goal completion
// premise is to check logs for if there are any completed with todays date
app.post('/logs', async(req, res) => {
    const {goalId} = req.body;

    try {
        // finds all goals of matching ID and same as the current date
        const alreadyCompleted = await pool.query('SELECT * FROM goal_logs WHERE goal_id = $1 AND date = CURRENT_DATE', [goalId]);

        if (alreadyCompleted.rows.length > 0) { // more than one row means already logged for today, returns
            return res.status(400).json({message: "Goal already completed today"}); // status 400 is bad request
        }

        // table set by default to have adding the current date
        const newLog = await pool.query('INSERT INTO goal_logs (goal_id, completed) VALUES ($1, TRUE) RETURNING *', [goalId]);
        res.json(newLog.rows[0]); // sends this new entry
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// used for getting the goals that are completed today
app.get('/logs/today', async(req, res) => {
    try {
        const result = await pool.query('SELECT goal_id FROM goal_logs WHERE date = CURRENT_DATE'); // matching current date
        const completedGoalIds = result.rows.map(row => row.goal_id);
        res.json(completedGoalIds);
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// ****************************** XP ******************************
// get to here returns a map of (skill id, xp)
app.get('/xp', async(req, res) => {
    try {
        // joins 3 tables, total minutes completed becomes xp
        const result = await pool.query(`
            SELECT s.id AS skill_id, SUM(g.daily_minutes) AS xp
            FROM skills s 
            JOIN goals g ON g.skill_id = s.id
            JOIN goal_logs gl ON gl.goal_id = g.id
            WHERE gl.completed = TRUE
            GROUP BY s.id
        `);

        const xpMap = {};
        // for each row, map (skill id: xp)
        result.rows.forEach(row => {
            xpMap[row.skill_id] = parseInt(row.xp);
        });

        res.json(xpMap);
        
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// ****************************** OPENAI ******************************
// sending a post to generate an image
app.post('/generate-image', async (req, res) => {
    const {prompt} = req.body;

    if (!prompt || !prompt.trim()) {
        return res.status(400).json({ error: 'Prompt is missing' });
    }

    // check the toggle:
    if (!USE_IMAGE_API) {
        console.log('Skipping image generation for testing (USE_IMAGE_API = false)');
        // Return a default or placeholder image URL
        return res.json({ imageUrl: "https://via.placeholder.com/256?text=Skill" });
    }

    try {
        // API call
        console.log('Image prompt:', prompt);

        const response = await openai.images.generate({
            model: "dall-e-2",
            prompt,
            n: 1,
            size: "256x256", 
        });

        const imageUrl = response.data[0].url;
        res.json({imageUrl}); // sends 
        
    } catch (error) {
        console.error('Image generation failed:', error.response?.data || error.message);
        res.status(500).send('Server error');
    }
});

// starts server and begins listening
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
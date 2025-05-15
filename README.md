# 🎯 Gamified Goal Tracker

A web app that helps users build habits and achieve goals through XP-based progression, skill tracking, and daily consistency. Features fun visuals, goal streaks, and AI-generated skill icons.

---

## Tech Stack
- React + Vite
- Node.js + Express
- PostgreSQL
- OpenAI DALL-E API
- Axios, CSS Modules

## 🌟 Features

- Add skills with custom names and generated icons
- Add goals under each skill with daily minute targets
- Stores data with PostgreSQL and handles POST, GET, PUT, etc
- Track daily completions — resets automatically at midnight
- XP bars per skill, with level system (200 XP = 1 level)
- Clean UI using CSS with nice buttons and colors 
- Working popup modals for goal and skill entry
- Confirmation prompts for deletions
- AI-generated icons for each skill (via OpenAI DALL·E API)
- Live clock and daily reset info

## Image:

![Goal Tracker Demo](images/Goal%20Tracker%20Demo.png)

## Project Structure
```
client/      # React frontend
server/      # Express backend
db/          # SQL table setup info
images/      # images
```

The `.env.example` file is in the server.  Change the variables to your API keys and database URLs and then rename it to `.env` to get it to work

## PostgreSQL Database Setup

The app uses **PostgreSQL** for storing skills, goals, logs, and XP data.

### 1. 📂 Files

- **`init.sql`**: Contains schema definitions (tables, sequences, constraints, relationships).
- **`seed.sql`**: Optional file that inserts example data into the database for testing/demo purposes.

### 2. 📥 Create the Database

In `psql` or pgAdmin, run:

```bash
CREATE DATABASE goal_tracker;
```

### 3. Initialize Schema

``` bash
psql -U your_username -d goal_tracker -f db/init.sql
```

### 4. Seed Data (optional)

If you want to load prexisting data:
``` bash
psql -U your_username -d goal_tracker -f db/seed.sql
```

### 5. Connect Backend

Ensure `.env` is set up to connect to the database:

```
DB_USER=your_username
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=goal_tracker
```

## App.jsx Overview (Client)

This is the main React component of the **Gamified Goal Tracker** app, handling frontend logic, state, and UI for tracking and leveling up through skill-based goals.

---

### 🌟 Features Implemented

- **Real-time Clock**  
  - Top-right clock updates every second, displaying current time and daily reset reminder.
  - Goals reset at midnight everyday and are able to be completed again

- **Add Skills**  
  - Modal popup for entering a new skill name  
  - Automatically generates an icon using OpenAI’s image API

- **Add Goals**  
  - Modal form to associate a goal with a skill, including name, description, and daily time target

- **✅ Complete Goals**  
  - Checkbox marks a goal as completed for the current day  
  - Completion awards XP to the associated skill

- **XP System**  
  - Each skill tracks XP based on completed goals  
  - Uses OpenAI's DALL-E API to generate images
  - XP bar shows current progress, and every 200 XP equals 1 level

- **Skill Progress UI**  
  - Cleanly styled cards display each skill’s name, level, XP bar, and icon

- **Deletion with Confirmation**  
  - Both skills and goals can be deleted via a ✖️ icon  
  - Pop-up confirmation prevents accidental deletion

---

### 🔧 Technical Highlights

- Built with **React** and hooks like `useState` and `useEffect`
- Uses **Axios** for all backend API interactions
- Popup modals controlled by `showSkillModal` and `showGoalModal` state
- Central state includes:
  - `skills`, `goals`, `completedToday`
  - `xpMap` — maps skill IDs to accumulated XP
  - `currentTime` — for live clock updates

---

### 📬 API Endpoints Hit

- `GET /skills` — fetches all skills  
- `POST /skills` — adds new skill with generated image  
- `GET /goals` — fetches all goals  
- `POST /goals` — adds new goal  
- `POST /logs` — logs a goal completion  
- `GET /logs/today` — gets today’s completed goal IDs  
- `GET /xp` — retrieves XP per skill  
- `DELETE /goals/:id` and `DELETE /skills/:id` — for deletion with confirmation


## Express Backend Overview (Server)

This is the backend server for the **Gamified Goal Tracker** app, built with **Express.js** and connected to a **PostgreSQL** database. It handles CRUD operations, goal completion logging, XP tracking, and optional AI-generated images via the OpenAI API.

---

### Tech Stack

- **Express.js** for server routing
- **PostgreSQL** as the database
- **Axios** for outbound API calls (e.g., OpenAI)
- **dotenv** for managing secrets
- **CORS** for frontend-backend communication
- **OpenAI SDK** for image generation

---

### API Routes

#### 🔹 Skills

- `POST /skills`  
  Adds a new skill to the database with an optional AI-generated image URL.

- `GET /skills`  
  Retrieves all skills from the database, sorted by ID.

- `DELETE /skills/:id`  
  Deletes a skill **and** all related goals and logs (cascading).

#### 🔹 Goals

- `POST /goals`  
  Adds a goal with a name, description, daily time, and skill association.

- `GET /goals`  
  Returns all goals in the database.

- `DELETE /goals/:id`  
  Deletes a goal and its associated log entries.

#### 🔹 Logs

- `POST /logs`  
  Logs a goal completion for **today**, ensuring no duplicate logs for the same day.

- `GET /logs/today`  
  Returns an array of goal IDs completed on the current date.

#### 🔹 XP Tracking

- `GET /xp`  
  Aggregates XP per skill based on completed goal logs and daily minutes.

#### 🔹 OpenAI Integration

- `POST /generate-image`  
  Generates a skill icon using DALL·E based on a prompt (e.g., "A symbolic icon for the skill 'Chess'").

  - Uses the environment variable `USE_IMAGE_API` to **toggle image generation**:
    - `true`: Calls OpenAI API.
    - `false`: Returns a placeholder image (great for testing).

---

### Environment Variables (.env)

Note: the USE_IMAGE_API is used for testing to avoid constant API calls that will burn costs

```env
PORT=5050
OPENAI_API_KEY=your_openai_key_here
USE_IMAGE_API=true
```
# 🟡 Golden Hours

  - Golden Hours is an Agentic AI system designed to make accident management faster, safer, and more efficient.
  - It integrates IoT sensors, AI decision-making, and smart navigation to reduce response times and save lives.

# 🌍 Problem Statement

  - Road accidents often go undetected or unreported on time, leading to delays in medical help. The first 60 minutes (Golden Hour) after an accident are crucial for   survival. Our system ensures:

  - Automatic detection of accidents with IoT & OBD sensors.

  - Direct navigation to the nearest hospital for ambulance personnel.

  - Smart traffic light control to give ambulances a clear path.

## ⚡ Key Features
## 1️⃣ Accident Detection (Reactive Agent)

  - Monitors OBD-II / IoT sensor data.

  - Detects sudden deceleration or high-impact collisions.

  - Triggers an automatic accident alert with GPS coordinates.

## 2️⃣ Nearest Hospital Navigation (Goal-based Agent)

  - Uses Mapbox API to locate the closest hospitals.

  - Displays options directly in the Android app.

  - One-click Start Navigation for ambulance drivers.

## 3️⃣ Smart Traffic Management (Utility-based Agent)

  - Accident alert integrates with traffic light IoT systems.

  - Traffic signals along the ambulance route turn green automatically.

  - Ensures fast, uninterrupted travel to hospitals.

## 4️⃣ Report Writting on the patient health

  - Patient report are necessary for many procedures such as he is diabetic or not, cause of injury and the observation made by ambulance personal.

  - Patient current health shall be given to the doctor so he can easily make his predictions and check for potential dangers.

  - 

## 🧠 Agentic AI Design

  - Golden Hours is a Goal-Based Rational Agent:

  - Perceives: Accident signals, GPS location, traffic light states.

  - Thinks: Identifies hospital routes, optimizes path.

  - Acts: Sends alerts, starts navigation, controls traffic lights.

## 🛠️ Tech Stack

  - Frontend: Flutter (Android App for ambulance staff).

  - Backend: Python (Flask / FastAPI).

## APIs:

  - Mapbox (Hospitals & Navigation).

  - IoT Integration: OBD-II / ECU data (simulated).

  - Database: Firebase / SQLite (for accident logs & hospital data).

## 🚀 How It Works (Flow)

  - Vehicle sensors → detect accident.

  - System triggers Golden Hours Agent.

  - Nearest hospital suggestions appear on ambulance app.

  - Driver clicks Start Navigation.

  - Traffic signals on the route turn green automatically.


## 🏆 Scocial Impact

  - Reduces emergency response time.
  
  - Saves lives during the Golden Hour.

  - Lesser Legal Troubles as AI automatically finds and report a crash.
  
  - Scalable to smart cities & intelligent traffic systems.

    


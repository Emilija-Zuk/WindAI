import React, { useEffect } from 'react';
import './styles/styles.css';  
import './styles/waves.css';
import { useNavigate } from 'react-router-dom';  
import { Routes, Route } from 'react-router-dom';
import Test from './test'; 

import { BrowserRouter } from 'react-router-dom';


function App() {
  const navigate = useNavigate(); 

  // Handle redirects
  const redirectToTest = () => navigate('/test');  
  const redirectToWind = () => navigate('/wind');  
  const redirectToAbout = () => navigate('/about'); 

  useEffect(() => {
    // Fetching waves.html dynamically
    console.log('Attempting to fetch waves.html...');
    fetch('waves.html')
      .then((response) => response.text())
      .then((data) => {
        document.getElementById('waves-container').innerHTML = data;
      })
      .catch((error) => console.error('Error loading waves:', error));
  }, []);  // Empty array ensures this runs only once on mount

  return (
    <div className="App">
      <header className="App-header">
        {/* Background container */}
        <div id="waves-container" className="background"></div>
  
        {/* SVG */}
        <svg className="half-circle-svg" viewBox="0 -25 300 50">
          <path id="half-circle-path" d="M 20 130 A 130 130 0 0 1 280 130" fill="none" stroke="none" />
          <text className="half-circle-text">
            <textPath href="#half-circle-path" startOffset="50%">
              WELCOME EM!!
            </textPath>
          </text>
        </svg>
  
        {/* Buttons */}
        <div className="button-container">
          <button id="test" type="button" onClick={redirectToTest}>
            <i className="fa fa-cogs"></i> Backend Test
          </button>
          <button id="wind" type="button" onClick={redirectToWind}>
            <i className="fa fa-wind"></i> Wind App
          </button>
          <button id="about" type="button" onClick={redirectToAbout}>
            <i className="fa fa-info-circle"></i> About
          </button>
        </div>
      </header>
  
      {/* Define Routes */}
      <Routes>
        <Route path="/test" element={<Test />} />
        {/* Add other routes for wind and about if needed */}
      </Routes>
    </div>
  );
  
}

export default App;

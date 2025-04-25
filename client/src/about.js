import React from 'react';
import './styles/styles.css';  // Assuming styles are in the same folder
import './styles/waves.css';
import { useNavigate } from 'react-router-dom';

const About = () => {
  const navigate = useNavigate();

  // Handle button click navigation
  const handleWorkClick = () => {
    // Implement any action when "Work" button is clicked
    console.log('Work clicked');
  };

  const handleSportsClick = () => {
    // Implement any action when "Sports" button is clicked
    console.log('Sports clicked');
  };

  const handleMusicClick = () => {
    // Implement any action when "Music" button is clicked
    console.log('Music clicked');
  };

  return (
    <div className="about-container">
      <header className="about-header">
        {/* Image Container */}
        <div className="image-container">
          <img src="public/images/me.jpg" alt="Me" />
        </div>

        {/* Text Container */}
        <div className="text-container">
          <p>Software Developer</p>
          <p>Click for more info..</p>
        </div>

        {/* Button Container */}
        <div className="button-container">
          <div>
            <button onClick={handleWorkClick}>
              <i className="fa fa-briefcase"></i> Work
            </button>
          </div>
          <div>
            <button onClick={handleSportsClick}>
              <i className="fa fa-dumbbell"></i> Sports
            </button>
          </div>
          <div>
            <button onClick={handleMusicClick}>
              <i className="fa fa-music"></i> Music
            </button>
          </div>
        </div>
      </header>
    </div>
  );
};

export default About;

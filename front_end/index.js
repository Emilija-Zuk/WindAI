

function redirectToTest() {
    window.location.href = 'test.html'; 
}

function redirectToWind() {
  window.location.href = 'wind.html'; 
}

function redirectToAbout() {
  window.location.href = 'about.html'; 
}

console.log("Attempting to fetch waves.html...");

fetch('waves.html')
  .then(response => response.text())
  .then(data => {
    document.getElementById('waves-container').innerHTML = data;
  })
  .catch(error => console.error("Error loading waves:", error));

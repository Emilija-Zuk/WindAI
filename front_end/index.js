



function redirectToTest() {
    window.location.href = 'test.html'; 
}



console.log("Attempting to fetch waves.html...");

fetch('waves.html')
  .then(response => response.text())
  .then(data => {
    console.log(data); // Log the content to verify it's loaded
    document.getElementById('waves-container').innerHTML = data;
  })
  .catch(error => console.error("Error loading waves:", error));

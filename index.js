let output = ""; 
let enteredText = "default";

// MS Login button listener
document.getElementById("ButtonMS").addEventListener("click", () => {
    console.log("Login MS");
});

// Form submission listener
document.getElementById("textForm").addEventListener("submit", (event) => {
    event.preventDefault(); // Prevent page refresh
    enteredText = document.getElementById("textInput").value;
    console.log("Text entered: " + enteredText);
});

// Output button listener
document.getElementById("output").addEventListener("click", () => {
    fetch('https://qitizwxnn0.execute-api.ap-southeast-2.amazonaws.com/test1/submit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ message: enteredText }) , 
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        output = JSON.parse(data.body).output; // Store output from the API response
        console.log("Output received: " + output); // Log output for debugging
        document.getElementById("outputTextArea").value = output; 
    })
    .catch(error => console.error('Error:', error));
});

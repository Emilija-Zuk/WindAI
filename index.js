let output = ""; 
let enteredText = "default";
let apiUrl = "";
let myAPI = "";

// MS Login button listener
document.getElementById("ButtonMS").addEventListener("click", () => {
    console.log("Login MS");
});

// Form submission listener
document.getElementById("textForm").addEventListener("submit", (event) => {
    event.preventDefault(); // Prevent page refresh
    enteredText = document.getElementById("textInput").value;
    console.log("Text entered: " + enteredText );
});

// Output button listener
document.getElementById("output").addEventListener("click", () => {
    fetchApiData().then(() => {
        if (!apiUrl) {
            console.error("API URL not set");
            return;
        }

        fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                    body: JSON.stringify({ message: enteredText + " api ID " + myAPI}) // Wrap it in a "body" field
            }),
        })
        .then(response => response.json())
        .then(data => {
            output = JSON.parse(data.body).output; // Store output from the API response
            console.log("Output received: " + output); // Log output for debugging
            document.getElementById("outputTextArea").value = output; 
        })
        .catch(error => console.error('Error:', error));
    });
});



function fetchApiData() {
    return fetch('https://windapp1.s3.ap-southeast-2.amazonaws.com/api_id.txt')
        .then(response => response.text())
        .then(apiId => {
            myAPI = apiId.trim();
            apiUrl = `https://${apiId.trim()}.execute-api.ap-southeast-2.amazonaws.com/test1/submit`;
        })
        .catch(error => console.error("Error fetching API ID:", error));
}




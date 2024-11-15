let output = ""; 
let enteredText = "nothing was sent yet";
let apiUrl = "";
let myAPI = "";


document.getElementById("textForm").addEventListener("submit", (event) => {
    event.preventDefault(); // Prevent page refresh
    enteredText = document.getElementById("textInput").value;
    console.log("Text entered: " + enteredText);

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
                    body: JSON.stringify({ message: enteredText + "'"}) 
            }),
        })
        .then(response => response.json())
        .then(data => {
            output = JSON.parse(data.body).output; 
            console.log("Output received: " + output); 
            document.getElementById("outputTextArea").value = output; 
        })
        .catch(error => console.error('Error:', error));
    });
});



function fetchApiData() {
    return fetch('https://s3.ap-southeast-2.amazonaws.com/www.emilija.pro/api_id.txt') // change it to a variable
        .then(response => response.text())
        .then(apiId => {
            myAPI = apiId.trim();
            apiUrl = `https://${apiId.trim()}.execute-api.ap-southeast-2.amazonaws.com/test1/submit`;
        })
        .catch(error => console.error("Error fetching API ID:", error));
}

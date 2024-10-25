
var output = "hellooooo";

// document.getElementById("textForm").addEventListener("submit", (event) => {
//     event.preventDefault(); 
//     const enteredText = document.getElementById("textInput").value;
//     console.log("Text entered: " + enteredText);
// });


document.getElementById("ButtonMS").addEventListener("click", () => {
    console.log("Login MS");

});

document.getElementById("output").addEventListener("click", () => {
    document.getElementById("outputTextArea").value = output;

});



document.getElementById("textForm").addEventListener("submit", (event) => {
    event.preventDefault();
    const enteredText = document.getElementById("textInput").value;

    fetch('https://qitizwxnn0.execute-api.ap-southeast-2.amazonaws.com/test1/submit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ text: enteredText }),
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById("outputTextArea").value = data.output;
    })
    .catch(error => console.error('Error:', error));
});


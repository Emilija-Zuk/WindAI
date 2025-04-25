// src/Test.js
import React, { useState } from 'react';

const Test = () => {
  const [enteredText, setEnteredText] = useState("nothing was sent yet");
  const [output, setOutput] = useState("");
  const [apiUrl, setApiUrl] = useState("");
  const [myAPI, setMyAPI] = useState("");

  const fetchApiData = async () => {
    try {
      const response = await fetch('https://s3.ap-southeast-2.amazonaws.com/www.emilija.pro/api_id.txt');
      const apiId = await response.text();
      setMyAPI(apiId.trim());
      setApiUrl(`https://${apiId.trim()}.execute-api.ap-southeast-2.amazonaws.com/test1/submit`);
    } catch (error) {
      console.error("Error fetching API ID:", error);
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault(); // Prevent page refresh
    console.log("Text entered: " + enteredText);

    await fetchApiData();

    if (!apiUrl) {
      console.error("API URL not set");
      return;
    }

    try {
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          body: JSON.stringify({ message: enteredText + "'" }),
        }),
      });
      const data = await response.json();
      const outputReceived = JSON.parse(data.body).output;
      setOutput(outputReceived);
      console.log("Output received: " + outputReceived);
    } catch (error) {
      console.error('Error:', error);
    }
  };

  return (
    <div>
      <h1>Test Page</h1>
      <form id="textForm" onSubmit={handleSubmit}>
        <label>
          Enter text:
          <input
            type="text"
            id="textInput"
            value={enteredText}
            onChange={(e) => setEnteredText(e.target.value)}
          />
        </label>
        <button type="submit">Submit</button>
      </form>

      <textarea
        id="outputTextArea"
        value={output}
        readOnly
        rows="4"
        cols="50"
      />
    </div>
  );
};

export default Test;

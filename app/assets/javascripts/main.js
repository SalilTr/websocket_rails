document.addEventListener('DOMContentLoaded', () => {
  let id;
  let messages = [];
  const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
  const ws = new WebSocket(`${protocol}//localhost:3000/cable`);

  const setId = (_id) => {
    id = _id;
  };

  // Fetch messages when the page loads
  fetch('/messages')  // Assuming you have a messages endpoint in your Rails application
    .then(response => response.json())
    .then(data => {
      const fetchedMessages = data.messages || [];
      messages = [...messages, ...fetchedMessages.map(msg => `Existing message: ${msg.body}`)];
      document.getElementById('message').innerText = messages.join('\n');
    })
    .catch(error => console.error('Error fetching messages:', error));

  // Your existing WebSocket code...
  ws.onopen = () => {
    console.log("Connected to WebSocket server");
    setId(Math.random().toString(36).substring(2, 11));

    const subscriptionMessage = JSON.stringify({
      command: "subscribe",
      identifier: JSON.stringify({
        id: id,
        channel: "MessagesChannel"
      })
    });

    ws.send(subscriptionMessage);

    document.getElementById('id').innerText = id;
    document.getElementById('message').innerText = messages.join('\n');
  };



  // Your existing WebSocket code...
  ws.onclose = () => {
    console.log("WebSocket connection closed");
  };

  // Your existing WebSocket code...
  ws.onerror = (error) => {
    console.error("WebSocket error:", error);
  };

  // Your existing WebSocket code...
// app/assets/javascripts/main.js
document.getElementById('updateMessageButton').addEventListener('click', () => {
  const body = document.getElementById('inputMessage').value.trim();

  if (body !== "") {
    // Post the new message to the server
    fetch('/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ body: body }),
   
    })
      .then(response => {
        if (response.ok) {
          return response.json();
             console.log(body);
        } else if (response.status === 422) {
          throw new Error('Validation error. Please check your input.');
        } else {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
      })
      .then(data => {
        // Handle the response, if needed
        console.log('Server response:', data);
      })
      .catch(error => {
        console.error('Error posting message:', error);
        // Handle the error, e.g., show an alert or log it
      });

    // Update the WebSocket to broadcast the new message
    ws.send(JSON.stringify({ body: body }));
    console.log("Sent message to server:", body);
  }
});


});

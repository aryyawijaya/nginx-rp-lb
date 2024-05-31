import { useState } from 'react';
import './App.css'

function App() {
  const [apiResponse, setApiResponse] = useState<string | null>(null);

  const handleApiCall = async () => {
    try {
      const response = await fetch('http://192.168.1.6'); // Replace with your actual API URL
      if (response.ok) {
        const data = await response.json();
        setApiResponse(JSON.stringify(data, null, 2)); // Display the response as a formatted JSON string
      } else {
        setApiResponse('Error fetching data from the API');
      }
    } catch (error) {
      console.log(error)
      setApiResponse('An error occurred while fetching data');
    }
  };

  return (
    <div>
      <button onClick={handleApiCall}>Call API</button>
      {apiResponse && (
        <pre>{apiResponse}</pre>
      )}
    </div>
  );
}

export default App

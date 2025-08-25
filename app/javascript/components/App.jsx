import React, { useState } from 'react';
import SunDataForm from './SunDataForm';
import SunDataTable from './SunDataTable';
import SunDataLocation from './SunDataLocation';
import Footer from './Footer';
import { fetchSunEvents } from '../services/api';
import '../styles/App.css';
import { IoSunnySharp } from "react-icons/io5";
import { ImLocation2 } from "react-icons/im";

const App = () => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [lastQuery, setLastQuery] = useState(null); // store last request

  const handleFetchData = async (location, startDate, endDate) => {
    if (!location || !startDate || !endDate) {
      setError('Please fill all fields');
      return;
    }

    // check if request is same as current shown data
    const currentQuery = { location, startDate, endDate };
    if (
      lastQuery &&
      lastQuery.location === currentQuery.location &&
      lastQuery.startDate === currentQuery.startDate &&
      lastQuery.endDate === currentQuery.endDate
    ) {
      setError('You already have the results for this query');
      return;
    }

    setLoading(true);
    setError('');

    try {

    //Timezone issue fix  
		const start = new Date(startDate).toLocaleDateString('en-CA');
		const end = new Date(endDate).toLocaleDateString('en-CA'); 

		console.log("StartDate:", start); // "2025-08-01"
		console.log("EndDate:", end); // "2025-08-06"
		const response = await fetchSunEvents(location, start, end);
		setData(response.data || []);
		setLastQuery(currentQuery); // save the successful query
	} catch (err) {
      setError(err.response?.data?.error || 'Failed to fetch data');
      setData([]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="main-container">
      <div className="header-container">
        <div className="app-logo-container">
          <IoSunnySharp size={50} className="app-logo" />
          <h2>Sunrise Sunset App</h2>
        </div>

        <SunDataForm onSubmit={handleFetchData} loading={loading} />
      </div>

      {error && <div className="error">{error}</div>}

      <SunDataLocation data={data}/>


      <SunDataTable data={data} />

      <Footer></Footer>
    </div>

  );
};

export default App;

import React, { useState } from 'react';
import SunDataForm from './SunDataForm';
import SunDataTable from './SunDataTable';
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
      const response = await fetchSunEvents(location, startDate, endDate);
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

      {loading && <div className="loading">Loading data...</div>}

      {data.length > 0 && (
        <div className="location-container">
          <div className="location-header">
            <h3>
              <ImLocation2 />
              Location Information
            </h3>
          </div>
          <div className="location-info">
            <p>
              <strong>Location:</strong> {data[0].attributes.location}
            </p>
            <p>
              <strong>Latitude:</strong> {data[0].attributes.latitude}
            </p>
            <p>
              <strong>Longitude:</strong> {data[0].attributes.longitude}
            </p>
          </div>
        </div>
      )}

      <SunDataTable data={data} />
    </div>
  );
};

export default App;

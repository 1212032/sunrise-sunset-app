import React, { useState, useEffect } from 'react';
import SunDataForm from './SunDataForm';
import SunDataChart from './SunDataChart';
import SunDataTable from './SunDataTable';
import { fetchSunEvents } from '../services/api';
import '../styles/App.css';
import sunLogo from '../assets/sunrise-sunset-app-high-resolution-logo-transparent.png';
import { IoSunnySharp } from "react-icons/io5";


const App = () => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  

  const handleFetchData = async (location, startDate, endDate) => {
    if (!location || !startDate || !endDate) {
      setError('Please fill all fields');
      return;
    }

    setLoading(true);
    setError('');

    try {
      const response = await fetchSunEvents(location, startDate, endDate);
      setData(response.data || []);
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
                    <h2>Sunrise Sunset</h2>
				</div>

				<SunDataForm onSubmit={handleFetchData} loading={loading} />
			</div>

			{error && <div className="error">{error}</div>}

			{loading && <div className="loading">Loading data...</div>}

			<SunDataTable data={data} />
		</div>
  );
};

export default App;
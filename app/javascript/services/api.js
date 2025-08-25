import axios from 'axios';

const API_BASE_URL = '/api/v1';

export const fetchSunEvents = async (location, startDate, endDate) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/sun_events`, {
      params: {
        location,
        start_date: startDate,
        end_date: endDate
      }
    });
    return response.data;
  } catch (error) {
    throw new Error(error.response?.data?.error || 'Failed to fetch sun data');
  }
};

export const formatTime = (timeString) => {
  if (!timeString) return '';
  
  const parts = timeString.split(':');
  
  if (parts.length < 2) return timeString; 
  
  const hours = parts[0];
  const minutes = parts[1];
  const ampm = parts[2]?.split(' ')[1] || ''; 
  
  return `${hours}:${minutes} ${ampm}`.trim();
};
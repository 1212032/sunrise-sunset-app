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
  return timeString.split(':').slice(0, 2).join(':');
};
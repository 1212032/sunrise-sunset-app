import React, { useState } from 'react';
import '../styles/SunDataForm.css';

const SunDataForm = ({ onSubmit, loading }) => {
  const [formData, setFormData] = useState({
    location: '',
    startDate: '',
    endDate: ''
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(formData.location, formData.startDate, formData.endDate);
  };

  const handleChange = (e) => {
    setFormData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }));
  };

  const today = new Date().toISOString().split('T')[0];

  return (
    <form onSubmit={handleSubmit} className="sun-data-form">
      <input
        type="text"
        name="location"
        placeholder="Location (e.g., Lisbon, London)"
        value={formData.location}
        onChange={handleChange}
        className="form-input"
        required
      />
      
      <input
        type="date"
        name="startDate"
        value={formData.startDate}
        onChange={handleChange}
        max={formData.endDate}
        className="form-input"
        required
      />
      
      <input
        type="date"
        name="endDate"
        value={formData.endDate}
        onChange={handleChange}
        min={formData.startDate}
        className="form-input"
        required
      />
      
      <button
        type="submit"
        disabled={loading}
        className={`submit-button ${loading ? 'loading' : ''}`}
      >
        {loading ? 'Loading...' : 'Get Data'}
      </button>
    </form>
  );
};

export default SunDataForm;
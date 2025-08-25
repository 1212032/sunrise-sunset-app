import React, { useState } from 'react';
import '../styles/SunDataForm.css';
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

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
				placeholder="Location"
				value={formData.location}
				onChange={handleChange}
				className="form-input"
				required
        autoComplete="off"
        minLength={3}
			/>

			
      <DatePicker
        selected={formData.startDate}
        onChange={(date) =>
          setFormData((prev) => ({ ...prev, startDate: date }))
        }
        selectsStart
        startDate={formData.startDate}
        endDate={formData.endDate}
        maxDate={formData.endDate}
        placeholderText="Start Date "
        className="form-input"
        dateFormat="yyyy-MM-dd"
        required
        onChangeRaw={(e) => e.preventDefault()}   
      />

			<DatePicker
        selected={formData.endDate}
        onChange={(date) =>
          setFormData((prev) => ({ ...prev, endDate: date }))
        }
        selectsEnd
        startDate={formData.startDate}
        endDate={formData.endDate}
        minDate={formData.startDate}
        placeholderText="End Date "
        className="form-input"
        dateFormat="yyyy-MM-dd"
        required
        onChangeRaw={(e) => e.preventDefault()}   
      />

			<button
				type="submit"
				disabled={loading}
				className={`submit-button ${loading ? "loading" : ""}`}>
				{loading ? "Loading..." : "Get Data"}
			</button>
		</form>
  );
};

export default SunDataForm;
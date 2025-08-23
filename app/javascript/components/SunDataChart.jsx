import React from 'react';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer
} from 'recharts';
import { formatTime } from '../services/api';
import '../styles/SunDataChart.css';

const SunDataChart = ({ data }) => {
  const chartData = data.map(item => ({
    date: item.attributes.date,
    sunrise: formatTime(item.attributes.sunrise),
    sunset: formatTime(item.attributes.sunset),
    golden_hour: formatTime(item.attributes.golden_hour)
  }));

  return (
    <div className="sun-data-chart">
      <h2>Sun Data Chart</h2>
      <ResponsiveContainer width="100%" height={400}>
        <LineChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="date" />
          <YAxis label={{ value: 'Hour', angle: -90, position: 'insideLeft' }} />
          <Tooltip />
          <Legend />
          <Line type="monotone" dataKey="sunrise" stroke="#8884d8" name="Sunrise" />
          <Line type="monotone" dataKey="sunset" stroke="#82ca9d" name="Sunset" />
          <Line type="monotone" dataKey="golden_hour" stroke="#ffc658" name="Golden Hour" />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
};

export default SunDataChart;
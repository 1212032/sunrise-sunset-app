import React from 'react';
import { formatTime } from '../services/api';
import '../styles/SunDataTable.css';

const SunDataTable = ({ data }) => {
  return (
    <div className="sun-data-table">
      <h2>Sun Data Table</h2>
      <table className="data-table">
        <thead>
          <tr>
            <th>Date</th>
            <th>Sunrise</th>
            <th>Sunset</th>
            <th>Golden Hour</th>
            <th>Day Length</th>
          </tr>
        </thead>
        <tbody>
          {data.map((item, index) => (
            <tr key={index} className={index % 2 === 0 ? 'even' : 'odd'}>
              <td>{item.attributes.date}</td>
              <td>{formatTime(item.attributes.sunrise)}</td>
              <td>{formatTime(item.attributes.sunset)}</td>
              <td>{formatTime(item.attributes.golden_hour)}</td>
              <td>{item.attributes.day_length}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default SunDataTable;
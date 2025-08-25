import React from 'react';
import { ImLocation2 } from "react-icons/im"; // não esquecer do import

const SunDataLocation = ({ data }) => {
  return (
    <>
      {data && data.length > 0 && (
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
            <p>
              <strong>Timezone:</strong> {data[0].attributes.timezone}
            </p>
          </div>
        </div>
      )}
    </>
  );
};

export default SunDataLocation;

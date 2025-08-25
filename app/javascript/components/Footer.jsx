import React from 'react';
import '../styles/Footer.css';

const Footer = () => {
  return (
    <footer className="app-footer">
      Powered by{' '}
      <a 
        href="https://sunrisesunset.io/" 
        target="_blank" 
        rel="noopener noreferrer"
      >
        SunriseSunset.io
      </a>{' '}
      API
    </footer>
  );
};

export default Footer;
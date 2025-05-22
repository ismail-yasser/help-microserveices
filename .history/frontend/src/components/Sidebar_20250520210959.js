import React from 'react';
import { Link } from 'react-router-dom';
import './Sidebar.css'; // We'll create this file for styling

const Sidebar = () => {
  return (
    <nav className="sidebar bg-light">
      <div className="sidebar-sticky">
        <ul className="nav flex-column">
          <li className="nav-item">
            <Link className="nav-link" to="/dashboard">
              Dashboard
            </Link>
          </li>
          <li className="nav-item">
            <Link className="nav-link" to="/resources">
              Resource Library
            </Link>
          </li>
          <li className="nav-item">
            <Link className="nav-link" to="/help-center">
              Help Center
            </Link>
          </li>
          {/* Add more links as needed based on your services */}
        </ul>
      </div>
    </nav>
  );
};

export default Sidebar;

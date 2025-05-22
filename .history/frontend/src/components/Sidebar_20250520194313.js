import { Link } from 'react-router-dom';

function Sidebar() {
  return (
    <div className="d-flex flex-column flex-shrink-0 p-3 bg-light" style={{ width: '250px' }}>
      <h5 className="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
        Navigation
      </h5>
      <ul className="nav nav-pills flex-column mb-auto">
        <li className="nav-item">
          <Link to="/dashboard" className="nav-link link-dark">
            Dashboard
          </Link>
        </li>
        <li>
          <Link to="/resources" className="nav-link link-dark">
            Resource Library
          </Link>
        </li>
        <li>
          <Link to="/help-center" className="nav-link link-dark">
            Help Center
          </Link>
        </li>
        <li>
          <Link to="/partnerships" className="nav-link link-dark">
            Partnerships
          </Link>
        </li>
        <li>
          <Link to="/canvas" className="nav-link link-dark">
            Canvas Integration
          </Link>
        </li>
      </ul>
    </div>
  );
}

export default Sidebar;

import { useEffect, useState } from 'react';
import { getResources } from '../services/resourceService';

function ResourceLibraryPage() {
  const [resources, setResources] = useState([]);
  const [search, setSearch] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchResources = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        const data = await getResources(token);
        setResources(Array.isArray(data) ? data : []);
      } catch (err) {
        setError('Failed to fetch resources.');
      }
    };

    fetchResources();
  }, []);

  const filteredResources = resources.filter((resource) =>
    resource.title.toLowerCase().includes(search.toLowerCase())
  );

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  return (
    <div className="container mt-5">
      <h1 className="text-center">Resource Library</h1>
      <input
        type="text"
        className="form-control mb-3"
        placeholder="Search Resources"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />
      <ul className="list-group">
        {filteredResources.map((resource) => (
          <li key={resource._id} className="list-group-item">
            {resource.title}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default ResourceLibraryPage;

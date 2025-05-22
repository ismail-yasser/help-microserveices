import { useEffect, useState } from 'react';
import { getResources } from '../services/resourceService';

function ResourceLibraryPage() {
  const [resources, setResources] = useState([]);
  const [search, setSearch] = useState('');
  const [error, setError] = useState('');
  const [newResource, setNewResource] = useState('');
  const [uploader, setUploader] = useState('');

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

  const handleAddResource = () => {
    if (newResource.trim() === '' || uploader.trim() === '') return;
    setResources([
      ...resources,
      { _id: Date.now(), title: newResource, uploader },
    ]);
    setNewResource('');
    setUploader('');
  };

  const handleDeleteResource = (id) => {
    setResources(resources.filter((resource) => resource._id !== id));
  };

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
      <div className="mb-3">
        <input
          type="text"
          className="form-control mb-2"
          placeholder="Resource Title"
          value={newResource}
          onChange={(e) => setNewResource(e.target.value)}
        />
        <input
          type="text"
          className="form-control mb-2"
          placeholder="Uploader Name"
          value={uploader}
          onChange={(e) => setUploader(e.target.value)}
        />
        <button className="btn btn-primary" onClick={handleAddResource}>
          Add Resource
        </button>
      </div>
      <ul className="list-group">
        {filteredResources.map((resource) => (
          <li
            key={resource._id}
            className="list-group-item d-flex justify-content-between align-items-center"
          >
            <div>
              <strong>{resource.title}</strong> <br />
              <small>Shared by: {resource.uploader}</small>
            </div>
            <button
              className="btn btn-danger btn-sm"
              onClick={() => handleDeleteResource(resource._id)}
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default ResourceLibraryPage;

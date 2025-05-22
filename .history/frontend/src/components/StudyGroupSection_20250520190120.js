import { useEffect, useState } from 'react';
import { getStudyGroups } from '../services/studyGroupService';

function StudyGroupSection() {
  const [studyGroups, setStudyGroups] = useState([]);
  const [newGroup, setNewGroup] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchStudyGroups = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        const data = await getStudyGroups(token);
        setStudyGroups(Array.isArray(data.groups) ? data.groups : []);
      } catch (err) {
        setError('Failed to fetch study groups.');
      }
    };

    fetchStudyGroups();
  }, []);

  const handleCreateGroup = () => {
    if (newGroup.trim() === '') return;
    setStudyGroups([...studyGroups, { _id: Date.now(), name: newGroup }]);
    setNewGroup('');
  };

  const handleJoinGroup = (id) => {
    alert(`Joined group with ID: ${id}`);
  };

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  return (
    <div>
      <div className="mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Create New Group"
          value={newGroup}
          onChange={(e) => setNewGroup(e.target.value)}
        />
        <button className="btn btn-primary mt-2" onClick={handleCreateGroup}>
          Create Group
        </button>
      </div>
      <ul className="list-group">
        {studyGroups.map((group) => (
          <li key={group._id} className="list-group-item d-flex justify-content-between align-items-center">
            {group.name}
            <button
              className="btn btn-success btn-sm"
              onClick={() => handleJoinGroup(group._id)}
            >
              Join
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default StudyGroupSection;
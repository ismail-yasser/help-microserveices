import React, { useEffect, useState } from 'react';
import studyGroupService from '../services/studyGroupService';

const StudyGroupSection = () => {
  const [studyGroups, setStudyGroups] = useState([]);

  useEffect(() => {
    studyGroupService.getStudyGroups().then(setStudyGroups);
  }, []);

  return (
    <div>
      <h2>Study Groups</h2>
      <ul>
        {studyGroups.map((group, index) => (
          <li key={index}>{group.name}</li>
        ))}
      </ul>
    </div>
  );
};

export default StudyGroupSection;

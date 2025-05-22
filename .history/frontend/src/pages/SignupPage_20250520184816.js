import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { signup } from '../services/userService';

function SignupPage() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const navigate = useNavigate();

  const handleSignup = async (e) => {
    e.preventDefault();
    try {
      await signup({ name, email, password });
      setSuccess('Signup successful! You can now log in.');
      setError('');
      navigate('/login'); // Redirect to login page
    } catch (err) {
      setError('Signup failed. Please try again.');
      setSuccess('');
    }
  };

  return (
    <div className="container mt-5">
      <h1 className="text-center">Signup</h1>
      <form onSubmit={handleSignup} className="mt-4">
        <div className="mb-3">
          <input
            type="text"
            className="form-control"
            placeholder="Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </div>
        <div className="mb-3">
          <input
            type="email"
            className="form-control"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>
        <div className="mb-3">
          <input
            type="password"
            className="form-control"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>
        <button type="submit" className="btn btn-primary w-100">Signup</button>
      </form>
      {error && <p className="text-danger text-center mt-3">{error}</p>}
      {success && <p className="text-success text-center mt-3">{success}</p>}
    </div>
  );
}

export default SignupPage;

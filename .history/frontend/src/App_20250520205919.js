import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import SignupPage from './pages/SignupPage';
import DashboardPage from './pages/DashboardPage';


function App() {
  return (
    <Router>
      <div>
        <Header />
        <div className="d-flex">
          <Sidebar />
          <div className="flex-grow-1 p-3">
            <Routes>
              <Route path="/" element={<HelpCenterPage />} />
              <Route path="/login" element={<LoginPage />} />
              <Route path="/signup" element={<SignupPage />} />
              <Route
                path="/dashboard"
                element={
                  <PrivateRoute>
                    <DashboardPage />
                  </PrivateRoute>
                }
              />
              <Route path="/resources" element={<ResourceLibraryPage />} />
              <Route path="/help-center" element={<HelpCenterPage />} />
              <Route path="/help/:id" element={<HelpDetailPage />} />
            </Routes>
          </div>
        </div>
      </div>
    </Router>
  );
}

export default App;

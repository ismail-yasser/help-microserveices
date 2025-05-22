const axios = require('axios');

// Health endpoint test function
async function testHealthEndpoint(serviceName, url) {
  try {
    console.log(`Testing ${serviceName} health endpoint: ${url}`);
    const response = await axios.get(url);
    console.log(`✅ ${serviceName} health check successful - Status: ${response.status}`);
    console.log(`Response data:`, response.data);
    return true;
  } catch (error) {
    console.error(`❌ ${serviceName} health check failed: ${error.message}`);
    if (error.response) {
      console.error(`Status: ${error.response.status}`);
      console.error('Response data:', error.response.data);
    }
    return false;
  }
}

// Run the tests
async function runTests() {
  console.log('Starting health endpoint tests...\n');

  // If running in Kubernetes
  if (process.env.KUBERNETES_ENV === 'true') {
    await testHealthEndpoint('User Service (Kubernetes)', 'http://user-service:3000/api/health');
    await testHealthEndpoint('Help Service (Kubernetes)', 'http://help-service:3002/api/health');
  } else {
    // For local testing
    await testHealthEndpoint('User Service (Local)', 'http://localhost:3000/api/health');
    await testHealthEndpoint('Help Service (Local)', 'http://localhost:3002/api/health');
  }

  console.log('\nHealth endpoint tests completed');
}

runTests();

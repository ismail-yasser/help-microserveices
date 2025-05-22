const axios = require('axios');

// Health endpoint test function
async function testHealthEndpoint(serviceName, url) {
  try {
    console.log(`Testing ${serviceName} health endpoint: ${url}`);
    const startTime = Date.now();
    const response = await axios.get(url);
    const responseTime = Date.now() - startTime;
    
    console.log(`✅ ${serviceName} health check successful - Status: ${response.status}`);
    console.log(`Response time: ${responseTime}ms`);
    console.log(`Response data:`, response.data);
    
    // Validate response structure
    const data = response.data;
    if (data.status === 'ok' && data.service && data.timestamp) {
      console.log(`✓ Response format is valid`);
    } else {
      console.warn(`⚠️ Response format may not be standard. Expected {status:'ok', service:[name], timestamp:[iso-date]}`);
    }
    
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

// Check if in a Kubernetes environment
async function isKubernetesEnvironment() {
  try {
    const { execSync } = require('child_process');
    // Try to execute a kubectl command
    execSync('kubectl get nodes', { stdio: 'ignore' });
    return true;
  } catch (error) {
    return false;
  }
}

// Run kubectl exec to test health endpoints from a pod
async function testWithKubectlExec() {
  try {
    const { execSync } = require('child_process');
    
    console.log('Testing user-service health from test pod:');
    const userServiceResult = execSync('kubectl exec -it service-test-pod -- curl -s http://user-service:3000/api/health', { encoding: 'utf8' });
    console.log(userServiceResult);
    
    console.log('\nTesting help-service health from test pod:');
    const helpServiceResult = execSync('kubectl exec -it service-test-pod -- curl -s http://help-service:3002/api/health', { encoding: 'utf8' });
    console.log(helpServiceResult);
    
    return true;
  } catch (error) {
    console.error('Error testing with kubectl exec:', error.message);
    return false;
  }
}

// Run the tests
async function runTests() {
  console.log('Starting health endpoint tests...\n');

  const isKubernetes = await isKubernetesEnvironment();
  
  if (isKubernetes || process.env.KUBERNETES_ENV === 'true') {
    console.log('Detected Kubernetes environment');
    console.log('Checking if we can test from within the cluster using kubectl exec...');
    
    const execSuccess = await testWithKubectlExec();
    if (!execSuccess) {
      console.log('Falling back to direct HTTP requests...');
      await testHealthEndpoint('User Service (Kubernetes)', 'http://user-service:3000/api/health');
      await testHealthEndpoint('Help Service (Kubernetes)', 'http://help-service:3002/api/health');
    }
  } else {
    console.log('Testing in local environment');
    // For local testing
    await testHealthEndpoint('User Service (Local)', 'http://localhost:3000/api/health');
    await testHealthEndpoint('Help Service (Local)', 'http://localhost:3002/api/health');
  }

  console.log('\nHealth endpoint tests completed');
}

runTests();

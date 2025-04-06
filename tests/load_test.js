import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Define custom metrics
const errorRate = new Rate('errors');

// Test configuration
export const options = {
  stages: [
    { duration: '30s', target: 20 }, // Ramp up to 20 users over 30 seconds
    { duration: '1m', target: 20 },  // Stay at 20 users for 1 minute
    { duration: '30s', target: 0 },  // Ramp down to 0 users over 30 seconds
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests should complete within 500ms
    'errors': ['rate<0.1'],           // Error rate should be less than 10%
  },
};

// Main test function
export default function() {
  // Test Ganache blockchain API
  testGanacheAPI();
  
  // Test SonarQube API
  testSonarQubeAPI();
  
  // Test Jenkins API
  testJenkinsAPI();
  
  // Wait between iterations
  sleep(1);
}

// Test Ganache blockchain API
function testGanacheAPI() {
  const payload = JSON.stringify({
    jsonrpc: '2.0',
    method: 'eth_blockNumber',
    params: [],
    id: 1
  });
  
  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };
  
  const res = http.post('http://ganache:8545', payload, params);
  
  // Check if the response is valid
  const success = check(res, {
    'status is 200': (r) => r.status === 200,
    'has result': (r) => JSON.parse(r.body).result !== undefined,
  });
  
  // If any check fails, increase the error rate
  if (!success) {
    errorRate.add(1);
    console.log(`Ganache API test failed: ${res.status} ${res.body}`);
  } else {
    console.log(`Ganache block number: ${JSON.parse(res.body).result}`);
  }
}

// Test SonarQube API
function testSonarQubeAPI() {
  const res = http.get('http://sonarqube:9000/api/system/status');
  
  // Check if the response is valid
  const success = check(res, {
    'status is 200': (r) => r.status === 200,
    'is up': (r) => JSON.parse(r.body).status === 'UP',
  });
  
  // If any check fails, increase the error rate
  if (!success) {
    errorRate.add(1);
    console.log(`SonarQube API test failed: ${res.status} ${res.body}`);
  } else {
    console.log(`SonarQube status: ${JSON.parse(res.body).status}`);
  }
}

// Test Jenkins API
function testJenkinsAPI() {
  const res = http.get('http://jenkins:8080/api/json');
  
  // Check if the response is valid
  const success = check(res, {
    'status is 200 or 403': (r) => r.status === 200 || r.status === 403, // 403 is acceptable if authentication is required
  });
  
  // If any check fails, increase the error rate
  if (!success) {
    errorRate.add(1);
    console.log(`Jenkins API test failed: ${res.status} ${res.body}`);
  } else {
    if (res.status === 200) {
      console.log(`Jenkins API response: ${res.body.substring(0, 50)}...`);
    } else {
      console.log(`Jenkins API requires authentication: ${res.status}`);
    }
  }
}
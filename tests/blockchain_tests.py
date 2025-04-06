import pytest
import time
import requests
import json

# Basic Ethereum/Ganache test
def test_ganache_connection():
    """Test connection to Ganache blockchain"""
    try:
        response = requests.post(
            "http://ganache:8545",
            json={
                "jsonrpc": "2.0",
                "method": "eth_blockNumber",
                "params": [],
                "id": 1
            },
            headers={"Content-Type": "application/json"}
        )
        result = response.json()
        assert "result" in result, f"Failed to get block number: {result}"
        print(f"Connected to Ganache, current block: {int(result['result'], 16)}")
        return True
    except Exception as e:
        pytest.fail(f"Failed to connect to Ganache: {str(e)}")
        return False

# Basic Cosmos test
def test_cosmos_connection():
    """Test connection to Cosmos node"""
    try:
        response = requests.get("http://cosmos-node:26657/status")
        result = response.json()
        assert "result" in result, f"Failed to get Cosmos status: {result}"
        print(f"Connected to Cosmos node, chain ID: {result['result']['node_info']['network']}")
        return True
    except Exception as e:
        pytest.fail(f"Failed to connect to Cosmos node: {str(e)}")
        return False

# Basic Polkadot test
def test_polkadot_connection():
    """Test connection to Polkadot node"""
    try:
        # Simple HTTP request to check if node is running
        response = requests.post(
            "http://polkadot-node:9944",
            json={
                "jsonrpc": "2.0",
                "method": "system_health",
                "params": [],
                "id": 1
            },
            headers={"Content-Type": "application/json"}
        )
        result = response.json()
        assert "result" in result, f"Failed to get Polkadot health: {result}"
        print(f"Connected to Polkadot node, health: {result['result']}")
        return True
    except Exception as e:
        pytest.fail(f"Failed to connect to Polkadot node: {str(e)}")
        return False

# Basic Algorand test
def test_algorand_connection():
    """Test connection to Algorand node"""
    try:
        response = requests.get("http://algorand-node:4001/v2/status")
        result = response.json()
        assert "last-round" in result, f"Failed to get Algorand status: {result}"
        print(f"Connected to Algorand node, last round: {result['last-round']}")
        return True
    except Exception as e:
        pytest.fail(f"Failed to connect to Algorand node: {str(e)}")
        return False

if __name__ == "__main__":
    # Allow time for services to start
    time.sleep(5)
    test_ganache_connection()
    test_cosmos_connection()
    test_polkadot_connection()
    test_algorand_connection()
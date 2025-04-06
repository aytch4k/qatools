 # Use a multi-stage build for efficiency
FROM ubuntu:22.04 AS builder

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    unzip \
    python3 \
    python3-pip \
    openjdk-11-jdk \
    wget \
    pkg-config \
    libssl-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install Go (for Cosmos SDK, IBC, Filecoin)
ENV GO_VERSION=1.22.1
RUN wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Rust (for Polkadot Substrate, CosmWasm)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Node.js (for Solidity, The Graph, Hedera)
ENV NODE_VERSION=18
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Install Solidity (solc)
RUN npm install -g solc

# Skip Move installation due to build issues
RUN echo "Skipping Move installation"

# Install Python dependencies (PyTEAL for Algorand, Pytest)
RUN pip3 install pyteal pytest pytest-html

# Install Hardhat (Solidity testing)
RUN npm install -g hardhat

# Skip CosmWasm installation due to build issues
RUN echo "Skipping CosmWasm installation"

# Install Substrate CLI (Polkadot)
RUN cargo install subxt-cli

# Install Ganache (Ethereum-compatible blockchain)
RUN npm install -g ganache

# Install Selenium and Appium
RUN pip3 install selenium appium-python-client

# Install Locust (load testing)
RUN pip3 install locust

# Install JMeter (performance testing)
ENV JMETER_VERSION=5.6.3
RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
    && tar -xzf apache-jmeter-${JMETER_VERSION}.tgz -C /opt/ \
    && rm apache-jmeter-${JMETER_VERSION}.tgz
ENV PATH="/opt/apache-jmeter-${JMETER_VERSION}/bin:${PATH}"

# Install k6 (performance testing)
RUN curl -sSL https://github.com/grafana/k6/releases/download/v0.49.0/k6-v0.49.0-linux-amd64.tar.gz -o k6.tar.gz \
    && tar -xzf k6.tar.gz -C /usr/local/bin --strip-components=1 k6-v0.49.0-linux-amd64/k6 \
    && rm k6.tar.gz

# Install Newman (Postman CLI)
RUN npm install -g newman

# Install Allure (reporting)
RUN wget https://github.com/allure-framework/allure2/releases/download/2.27.0/allure-2.27.0.tgz \
    && tar -xzf allure-2.27.0.tgz -C /opt/ \
    && rm allure-2.27.0.tgz
ENV PATH="/opt/allure-2.27.0/bin:${PATH}"

# Install SonarQube Scanner CLI
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip \
    && unzip sonar-scanner-cli-5.0.1.3006-linux.zip -d /opt/ \
    && rm sonar-scanner-cli-5.0.1.3006-linux.zip
ENV PATH="/opt/sonar-scanner-5.0.1.3006-linux/bin:${PATH}"

# Final image
FROM ubuntu:22.04
COPY --from=builder /usr/local /usr/local
COPY --from=builder /root/.cargo /root/.cargo
COPY --from=builder /opt /opt
COPY --from=builder /usr/bin/python3 /usr/bin/python3
COPY --from=builder /usr/lib/python3 /usr/lib/python3
COPY --from=builder /usr/local/lib/python3.10 /usr/local/lib/python3.10

# Install runtime dependencies (including Firefox for Selenium)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    firefox \
    pkg-config \
    libssl-dev \
    cmake \
    wget \
    && wget https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz \
    && tar -xzf geckodriver-v0.33.0-linux64.tar.gz \
    && mv geckodriver /usr/bin/ \
    && chmod +x /usr/bin/geckodriver \
    && rm geckodriver-v0.33.0-linux64.tar.gz \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PATH="/usr/local/go/bin:/root/.cargo/bin:/opt/sonar-scanner-5.0.1.3006-linux/bin:/opt/apache-jmeter-${JMETER_VERSION}/bin:/opt/allure-2.27.0/bin:${PATH}"
ENV MOZ_HEADLESS=1
ENV GECKODRIVER_PATH=/usr/bin/geckodriver

# Working directory
WORKDIR /app

# Test directory will be mounted as a volume
RUN mkdir -p /app/tests

# Default command
CMD ["bash"]
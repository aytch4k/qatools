import pytest
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class TestWebUI:
    def setup_method(self):
        """Set up the WebDriver for each test"""
        firefox_options = Options()
        firefox_options.add_argument("--headless")
        
        # Connect to Selenium Grid
        self.driver = webdriver.Remote(
            command_executor="http://selenium-hub:4444/wd/hub",
            options=firefox_options
        )
        self.driver.implicitly_wait(10)
    
    def teardown_method(self):
        """Clean up after each test"""
        if self.driver:
            self.driver.quit()
    
    def test_google_search(self):
        """Test a basic Google search"""
        try:
            self.driver.get("https://www.google.com")
            
            # Accept cookies if the dialog appears
            try:
                accept_button = WebDriverWait(self.driver, 5).until(
                    EC.element_to_be_clickable((By.XPATH, "//button[contains(., 'Accept')]"))
                )
                accept_button.click()
            except:
                # Cookie dialog might not appear, continue with the test
                pass
            
            # Find the search box and enter a query
            search_box = self.driver.find_element(By.NAME, "q")
            search_box.send_keys("Selenium WebDriver")
            search_box.submit()
            
            # Wait for results to load
            WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.ID, "search"))
            )
            
            # Verify search results contain the expected text
            assert "Selenium WebDriver" in self.driver.page_source
            
            print("Google search test passed!")
            return True
        except Exception as e:
            pytest.fail(f"Web UI test failed: {str(e)}")
            return False
    
    def test_sonarqube_ui(self):
        """Test SonarQube UI is accessible"""
        try:
            self.driver.get("http://sonarqube:9000")
            
            # Wait for the page to load
            WebDriverWait(self.driver, 20).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )
            
            # Check if we're on the login page or already logged in
            assert "SonarQube" in self.driver.title
            
            print("SonarQube UI test passed!")
            return True
        except Exception as e:
            pytest.fail(f"SonarQube UI test failed: {str(e)}")
            return False
    
    def test_jenkins_ui(self):
        """Test Jenkins UI is accessible"""
        try:
            self.driver.get("http://jenkins:8080")
            
            # Wait for the page to load
            WebDriverWait(self.driver, 20).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )
            
            # Check if we're on the login page or already logged in
            assert "Jenkins" in self.driver.title
            
            print("Jenkins UI test passed!")
            return True
        except Exception as e:
            pytest.fail(f"Jenkins UI test failed: {str(e)}")
            return False

if __name__ == "__main__":
    # Allow time for services to start
    time.sleep(5)
    test = TestWebUI()
    test.setup_method()
    test.test_google_search()
    test.test_sonarqube_ui()
    test.test_jenkins_ui()
    test.teardown_method()
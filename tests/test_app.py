import unittest
import json
import os
from app import app, db, Vulnerability

class TestApp(unittest.TestCase):
    def setUp(self):
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'sqlite:///:memory:')
        self.client = app.test_client()
        
        with app.app_context():
            db.create_all()
    
    def tearDown(self):
        with app.app_context():
            db.session.remove()
            db.drop_all()

    def test_home_page(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)

    def test_get_vulnerabilities_empty(self):
        response = self.client.get('/api/vulnerabilities')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, [])

    def test_create_vulnerability(self):
        data = {
            'name': 'Test Vulnerability',
            'description': 'Test Description',
            'severity': 'High'
        }
        response = self.client.post('/api/vulnerabilities',
                                  data=json.dumps(data),
                                  content_type='application/json')
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json['name'], data['name'])
        self.assertEqual(response.json['description'], data['description'])
        self.assertEqual(response.json['severity'], data['severity'])

    def test_get_vulnerability(self):
        # Create test vulnerability
        data = {
            'name': 'Test Vulnerability',
            'description': 'Test Description',
            'severity': 'High'
        }
        create_response = self.client.post('/api/vulnerabilities',
                                         data=json.dumps(data),
                                         content_type='application/json')
        vuln_id = create_response.json['id']

        # Get the vulnerability
        response = self.client.get(f'/api/vulnerabilities/{vuln_id}')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['name'], data['name'])
        self.assertEqual(response.json['description'], data['description'])
        self.assertEqual(response.json['severity'], data['severity'])

    def test_update_vulnerability(self):
        # Create test vulnerability
        data = {
            'name': 'Test Vulnerability',
            'description': 'Test Description',
            'severity': 'High'
        }
        create_response = self.client.post('/api/vulnerabilities',
                                         data=json.dumps(data),
                                         content_type='application/json')
        vuln_id = create_response.json['id']

        # Update the vulnerability
        update_data = {
            'name': 'Updated Vulnerability',
            'description': 'Updated Description',
            'severity': 'Critical'
        }
        response = self.client.put(f'/api/vulnerabilities/{vuln_id}',
                                 data=json.dumps(update_data),
                                 content_type='application/json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['name'], update_data['name'])
        self.assertEqual(response.json['description'], update_data['description'])
        self.assertEqual(response.json['severity'], update_data['severity'])

    def test_delete_vulnerability(self):
        # Create test vulnerability
        data = {
            'name': 'Test Vulnerability',
            'description': 'Test Description',
            'severity': 'High'
        }
        create_response = self.client.post('/api/vulnerabilities',
                                         data=json.dumps(data),
                                         content_type='application/json')
        vuln_id = create_response.json['id']

        # Delete the vulnerability
        response = self.client.delete(f'/api/vulnerabilities/{vuln_id}')
        self.assertEqual(response.status_code, 204)

        # Verify it's deleted
        get_response = self.client.get(f'/api/vulnerabilities/{vuln_id}')
        self.assertEqual(get_response.status_code, 404)

if __name__ == '__main__':
    unittest.main()

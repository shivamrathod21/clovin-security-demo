import unittest
import json
from app import app, db, Vulnerability

class TestApp(unittest.TestCase):
    def setUp(self):
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
        self.client = app.test_client()
        with app.app_context():
            db.create_all()

    def tearDown(self):
        with app.app_context():
            db.session.remove()
            db.drop_all()

    def test_get_vulnerabilities(self):
        response = self.client.get('/api/vulnerabilities')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/json')

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
        self.assertIn('id', response.json)
        self.assertEqual(response.json['name'], data['name'])

    def test_get_single_vulnerability(self):
        # Create a test vulnerability
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

if __name__ == '__main__':
    unittest.main()

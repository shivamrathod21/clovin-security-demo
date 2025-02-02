from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

app = Flask(__name__)

# Configure SQLAlchemy
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Define Vulnerability model
class Vulnerability(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    severity = db.Column(db.String(20), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'severity': self.severity,
            'created_at': self.created_at.isoformat()
        }

# Create tables
with app.app_context():
    db.create_all()

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/vulnerabilities', methods=['GET'])
def get_vulnerabilities():
    vulnerabilities = Vulnerability.query.all()
    return jsonify([v.to_dict() for v in vulnerabilities])

@app.route('/api/vulnerabilities', methods=['POST'])
def create_vulnerability():
    data = request.get_json()
    
    if not all(k in data for k in ('name', 'description', 'severity')):
        return jsonify({'error': 'Missing required fields'}), 400
        
    vulnerability = Vulnerability(
        name=data['name'],
        description=data['description'],
        severity=data['severity']
    )
    db.session.add(vulnerability)
    db.session.commit()
    return jsonify(vulnerability.to_dict()), 201

@app.route('/api/vulnerabilities/<int:id>', methods=['GET'])
def get_vulnerability(id):
    vulnerability = Vulnerability.query.get_or_404(id)
    return jsonify(vulnerability.to_dict())

@app.route('/api/vulnerabilities/<int:id>', methods=['PUT'])
def update_vulnerability(id):
    vulnerability = Vulnerability.query.get_or_404(id)
    data = request.get_json()
    
    vulnerability.name = data.get('name', vulnerability.name)
    vulnerability.description = data.get('description', vulnerability.description)
    vulnerability.severity = data.get('severity', vulnerability.severity)
    
    db.session.commit()
    return jsonify(vulnerability.to_dict())

@app.route('/api/vulnerabilities/<int:id>', methods=['DELETE'])
def delete_vulnerability(id):
    vulnerability = Vulnerability.query.get_or_404(id)
    db.session.delete(vulnerability)
    db.session.commit()
    return '', 204

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)

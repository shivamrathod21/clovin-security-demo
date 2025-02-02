from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

app = Flask(__name__)

# Configure SQLAlchemy
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Vulnerability Model
class Vulnerability(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    severity = db.Column(db.String(20), nullable=False)
    description = db.Column(db.Text, nullable=False)
    reported_date = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.String(20), default='Open')

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'severity': self.severity,
            'description': self.description,
            'reported_date': self.reported_date.isoformat(),
            'status': self.status
        }

# Create tables
with app.app_context():
    db.create_all()

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/vulnerabilities', methods=['GET'])
def get_vulnerabilities():
    vulns = Vulnerability.query.all()
    return jsonify([v.to_dict() for v in vulns])

@app.route('/api/vulnerabilities', methods=['POST'])
def create_vulnerability():
    data = request.json
    required_fields = ['title', 'severity', 'description']
    
    if not data or not all(field in data for field in required_fields):
        return jsonify({
            "error": "Required fields: title, severity, description"
        }), 400
    
    if data['severity'] not in ['Low', 'Medium', 'High', 'Critical']:
        return jsonify({
            "error": "Severity must be one of: Low, Medium, High, Critical"
        }), 400
    
    vuln = Vulnerability(
        title=data['title'],
        severity=data['severity'],
        description=data['description']
    )
    db.session.add(vuln)
    db.session.commit()
    
    return jsonify(vuln.to_dict()), 201

@app.route('/api/vulnerabilities/<int:vuln_id>', methods=['GET'])
def get_vulnerability(vuln_id):
    vuln = Vulnerability.query.get_or_404(vuln_id)
    return jsonify(vuln.to_dict())

@app.route('/api/vulnerabilities/<int:vuln_id>', methods=['PUT'])
def update_vulnerability(vuln_id):
    vuln = Vulnerability.query.get_or_404(vuln_id)
    data = request.json
    if 'title' in data:
        vuln.title = data['title']
    if 'severity' in data:
        if data['severity'] not in ['Low', 'Medium', 'High', 'Critical']:
            return jsonify({
                "error": "Severity must be one of: Low, Medium, High, Critical"
            }), 400
        vuln.severity = data['severity']
    if 'description' in data:
        vuln.description = data['description']
    if 'status' in data:
        vuln.status = data['status']
    
    db.session.commit()
    return jsonify(vuln.to_dict())

@app.route('/api/vulnerabilities/<int:vuln_id>', methods=['DELETE'])
def delete_vulnerability(vuln_id):
    vuln = Vulnerability.query.get_or_404(vuln_id)
    db.session.delete(vuln)
    db.session.commit()
    return '', 204

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)

from flask import Flask, request, jsonify, render_template
import os
from datetime import datetime

app = Flask(__name__)

# Simple in-memory storage for vulnerabilities
vulnerabilities = []

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/vulnerabilities', methods=['GET'])
def get_vulnerabilities():
    return jsonify(vulnerabilities)

@app.route('/api/vulnerabilities', methods=['POST'])
def create_vulnerability():
    vuln = request.json
    required_fields = ['title', 'severity', 'description']
    
    if not vuln or not all(field in vuln for field in required_fields):
        return jsonify({
            "error": "Required fields: title, severity, description"
        }), 400
    
    if vuln['severity'] not in ['Low', 'Medium', 'High', 'Critical']:
        return jsonify({
            "error": "Severity must be one of: Low, Medium, High, Critical"
        }), 400
    
    vuln['id'] = len(vulnerabilities) + 1
    vuln['reported_date'] = datetime.now().isoformat()
    vuln['status'] = 'Open'
    vulnerabilities.append(vuln)
    return jsonify(vuln), 201

@app.route('/api/vulnerabilities/<int:vuln_id>', methods=['GET'])
def get_vulnerability(vuln_id):
    vuln = next((v for v in vulnerabilities if v['id'] == vuln_id), None)
    if vuln is None:
        return jsonify({"error": "Vulnerability not found"}), 404
    return jsonify(vuln)

@app.route('/api/vulnerabilities/<int:vuln_id>', methods=['PUT'])
def update_vulnerability(vuln_id):
    vuln = next((v for v in vulnerabilities if v['id'] == vuln_id), None)
    if vuln is None:
        return jsonify({"error": "Vulnerability not found"}), 404
    
    updated_vuln = request.json
    if not updated_vuln:
        return jsonify({"error": "No update data provided"}), 400
    
    if 'severity' in updated_vuln and updated_vuln['severity'] not in ['Low', 'Medium', 'High', 'Critical']:
        return jsonify({
            "error": "Severity must be one of: Low, Medium, High, Critical"
        }), 400
    
    vuln.update(updated_vuln)
    vuln['id'] = vuln_id
    return jsonify(vuln)

@app.route('/api/vulnerabilities/<int:vuln_id>', methods=['DELETE'])
def delete_vulnerability(vuln_id):
    vuln = next((v for v in vulnerabilities if v['id'] == vuln_id), None)
    if vuln is None:
        return jsonify({"error": "Vulnerability not found"}), 404
    
    vulnerabilities.remove(vuln)
    return '', 204

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)

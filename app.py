from flask import Flask, render_template, request, redirect, url_for, jsonify

app = Flask(__name__)

# Initial Data (In-memory database)
# This simulates a database where we store our clothing products
products = [
    {
        "id": 1, 
        "name": "Classic White Tee", 
        "price": 25.00, 
        "image": "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500"
    },
    {
        "id": 2, 
        "name": "Denim Jacket", 
        "price": 85.00, 
        "image": "https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?w=500"
    },
    {
        "id": 3, 
        "name": "Urban Hoodie", 
        "price": 55.00, 
        "image": "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500"
    }
]

# READ: Display all products on the home page
@app.route('/')
def home():
    return render_template('index.html', items=products)

# CREATE: Add a new product via the admin form
@app.route('/add', methods=['POST'])
def add_product():
    # Generate a new unique ID
    new_id = max([p['id'] for p in products]) + 1 if products else 1
    
    # Get data from the form request
    new_product = {
        "id": new_id,
        "name": request.form.get('name'),
        "price": float(request.form.get('price', 0)),
        "image": request.form.get('image') or "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=500"
    }
    
    products.append(new_product)
    # Redirect back to home to see the new item
    return redirect(url_for('home'))

# UPDATE: Edit an existing product's details
@app.route('/edit/<int:id>', methods=['POST'])
def edit_product(id):
    # Find the product by ID and update its fields
    for p in products:
        if p['id'] == id:
            p['name'] = request.form.get('name')
            p['price'] = float(request.form.get('price', 0))
            p['image'] = request.form.get('image')
            break
    return redirect(url_for('home'))

# DELETE: Remove a product from the list
@app.route('/delete/<int:id>')
def delete_product(id):
    global products
    # Create a new list excluding the item with the target ID
    products = [p for p in products if p['id'] != id]
    return redirect(url_for('home'))

# API Endpoint: Get products as JSON (Useful for testing or frontend JS)
@app.route('/api/products')
def get_products_json():
    return jsonify(products)

if __name__ == '__main__':
    # Debug mode enabled for easier development
    # Host 0.0.0.0 is required for Docker accessibility
    app.run(host='0.0.0.0', port=5000, debug=True)
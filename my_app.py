# /usr/bin/env
# -*- coding: utf-8 -*-

__author__ = 'terauchihiroki'
__version__ = '1.0.0'
__date__ = '20XX/XX/XX (Created: 2024/08/16)'

import os
from flask import Flask, render_template, request, redirect, url_for
from table import SnackTable
import table
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

an_engine = create_engine('sqlite:///test.db', echo=True)
app = Flask(__name__)

table.Base.metadata.create_all(an_engine)
a_session_maker = sessionmaker(bind=an_engine)
a_session = a_session_maker()

"""
index.htmlを応答する関数
"""
@app.route('/')
def index():
    snacks = a_session.query(SnackTable).all()

    return render_template('index.html', snacks=snacks)

"""
フォーム送信を行う関数
"""
@app.route('/submit', methods=['POST'])
def submit():
    name = request.form['column1']
    owner = request.form['column2']
    eatbale = request.form['column3']
    image = request.files['image']

    if image:
        image_path = os.path.join("static", "uploads", image.filename)
        print(f"image_path:::::::::::::{image_path}")
        image.save(image_path)
    insert_data(name,owner,eatbale,image.filename)

    return redirect(url_for('index'))

@app.route('/delete_snack', methods=['POST'])
def delete_snack():
    snack_id = request.form['snack_id']
    snack_to_delete = a_session.query(SnackTable).get(snack_id)
    if snack_to_delete:
        image_file = snack_to_delete.image
        a_session.delete(snack_to_delete)
        a_session.commit()

        if image_file:
            image_path = os.path.join(os.getcwd(), "static", "uploads", image_file)
            print(f"image_file -------- delete {image_path}")
            if os.path.isfile(image_path):
                os.remove(image_path)
    a_session.close()
    return redirect(url_for('index'))

"""
DBにデータを挿入する関数
"""
def insert_data(a_name, an_owner, re_eatable, an_image=None):
    try:
        new_snack = SnackTable(name=a_name, owner=an_owner, eatable=re_eatable, image=an_image)
        a_session.add(new_snack)
        a_session.commit()
    except Exception as an_exception:
        a_session.rollback()
        print(f"{an_exception}:error occuered in insert_data func")
    finally:
        view_all_record()
        a_session.close()
    return


"""
DB内に登録されている内容を見る関数
"""
def view_all_record():
    records = a_session.query(SnackTable).all()

    for a_record in records:
        print(a_record)
    return

if __name__ == '__main__':
    from werkzeug.serving import run_simple
    run_simple('127.0.0.1', 8000, app)
    

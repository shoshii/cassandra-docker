# -*- coding: utf-8 -*-
 
from jinja2 import Environment, FileSystemLoader
import os
import sys
import argparse
 
def generate_node_image(**kwargs):
    dir_path = './conf/'
    if not os.path.exists(dir_path):
        os.mkdir(dir_path)

    # テンプレートファイルが配置されているディレクトリの指定
    env = Environment(loader=FileSystemLoader(("./template"),encoding="utf-8"))
 
    # テンプレートファイル名の指定
    template = env.get_template("cassandra.yaml")

    # テンプレートファイルを基に書き込む内容を作成
    # 辞書のキーはテンプレートファイル内の変数名
    out = template.render({
        'endpoint_snitch': 'GossipingPropertyFileSnitch',
        'listen_address': kwargs['nodeip'],
        'rpc_address': kwargs['nodeip'],
        'seeds': kwargs['seeds']
    })

    # ファイルを新規作成し、書き込み
    with open("{}/cassandra.yaml".format(dir_path), "w", encoding="utf-8") as fw:
        fw.write(out)
   
    # テンプレートファイル名の指定
    template = env.get_template("cassandra-rackdc.properties")
    out = template.render({
        'dc': kwargs['dc'],
        'rack': kwargs['rack']
    })
    with open("{}/cassandra-rackdc.properties".format(dir_path), "w", encoding="utf-8") as fw:
        fw.write(out)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("nodeip", type=str)
    parser.add_argument("seeds", type=str)
    parser.add_argument("--dc", type=str)
    parser.add_argument("--rack", type=str)
    args = parser.parse_args()
    generate_node_image(nodeip=args.nodeip, seeds=args.seeds, dc=args.dc, rack=args.rack)

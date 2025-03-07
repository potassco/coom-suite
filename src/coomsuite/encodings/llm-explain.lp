#script(python)
from clingo.symbol import String
from openai import OpenAI
import os
from pathlib import Path


prompt = """

Please give a natural language sentence that reads out the boolean statement I give you

Here are some examples:

count(root.carrier.bag)+count(root.frame.bag)<=4
Expected response: "The number of bags of the carrier plus the number of bags of the frame should be smaller than 4"

!root.carrier[0].bag[0].material[0]=Leather||root.carrier[0].bag[0].capacity[0]=B10
Expected response: "If the material of the bag of the carrier is leather then the capacity of the bag of the carrier should be B10"
Notice that this is actually not A or B which you should interpret as an if.

Notice that you don't need to mention "root" explicitly and that the paths with the dot represent a path to a part

Now do it for:
{constraint}

"""

def llm(a):
    client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

    response =client.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": prompt.format(constraint=a),
                }
            ],
            model="gpt-4o",
        )
    response_message = response.choices[0].message.content.strip('"')

    return String(response_message)
#end.

constraint_explanation((ID,M),@llm(M)):-constraint((ID,M),"boolean").

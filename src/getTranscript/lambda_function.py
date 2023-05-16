from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import JSONFormatter
import json
import math       
import boto3



client = boto3.client('comprehend')
formatter = JSONFormatter()


def lambda_handler(event, context):

    transcript = YouTubeTranscriptApi.get_transcript(event["videoId"])
    formattedTranscript = formatter.format_transcript(transcript)
    python_obj = json.loads(formattedTranscript)

    transcript_text = ''

    for value in python_obj:
        # print(value["text"])
        transcript_text += value["text"] + ' '

    # print(python_obj[1]["text"])
    loop_index = math.ceil(len(transcript_text)/3000)
    print(len(transcript_text))
    print(loop_index)

    listObj = []
    for n in range(loop_index):
        startCharacter = n * 3000
        endCharacter = startCharacter + 2999
        textSnippet = transcript_text[startCharacter:endCharacter]     
        response = client.detect_sentiment(
            Text=textSnippet,
            LanguageCode='en'
        )
        listObj.append(response["SentimentScore"])

    
    return listObj
    





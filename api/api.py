from __future__ import print_function

import argparse
import json
import requests
import random

try:
    # For Python 3.0 and later
    from urllib.error import HTTPError
    from urllib.parse import quote
except ImportError:
    # Fall back to Python 2's urllib2 and urllib
    from urllib.request import HTTPError
    from urllib import quote


API_KEY="j_v7888BtpDfkf63L1k1i4eftbecVLmcaP1Dn85sQgqUsONNGn_rC9Lmkwk3r0jJg-Q2Btg-4em73jaWqJmQ5GoBXi72ErtURPYY2K7YZV494U0ir6QVZ6r1L6huY3Yx" 


# API constants, you shouldn't have to change these.
API_HOST = 'https://api.yelp.com'
SEARCH_PATH = '/v3/businesses/search'
BUSINESS_PATH = '/v3/businesses/'


SEARCH_LIMIT = 1
DEFAULT_RADIUS = 40000
OFFSET_MULTIPLIER = 1000


def request(host, path, api_key, url_params=None):
    """Given your API_KEY, send a GET request to the API.
    Args:
        host (str): The domain host of the API.
        path (str): The path of the API after the domain.
        API_KEY (str): Your API Key.
        url_params (dict): An optional set of query parameters in the request.
    Returns:
        dict: The JSON response from the request.
    Raises:
        HTTPError: An error occurs from the HTTP request.
    """
    url_params = url_params or {}
    url = '{0}{1}'.format(host, quote(path.encode('utf8')))
    headers = {
        'Authorization': 'Bearer %s' % api_key,
    }

    print(u'Querying {0} ...'.format(url))

    response = requests.request('GET', url, headers=headers, params=url_params)

    return json.loads(response.text)


def get_business(api_key, business_id):
    """Query the Business API by a business ID.
    Args:
        business_id (str): The ID of the business to query.
    Returns:
        dict: The JSON response from the request.
    """
    business_path = BUSINESS_PATH + business_id

    return request(API_HOST, business_path, api_key)


def request_businesses(args):
    """Send a list of businesses and errors back to the client based on set parameters.
    Args:
        args (dict): A dictionary containing all pertinent information for the request.
            (key) activities (list): A list of dictionaries that contains info for each activity.
                activity (dict): A dictionary containing individual activity info.
                    (key) term (string): The category of activity to search for. ex. (dinner).
            (key) latitude (decimal): The latitude of the search location.
            (key) longitude (decimal): The longitude of the search location.
    Returns:
        dict: A list of activities and errors returned from the requests
            (key) activities (list): A list of the JSON responses generated by the requests.
            (key) errors (list): A list of the errors generated by the requests.
    """
    response = {}
    return_args = {
        "activities": [],
        "errors": []
    }

    for activity in args["activities"]:
        parser = argparse.ArgumentParser()

        parser.add_argument('-q', '--term',
                            dest='term',
                            default=activity["term"],
                            type=str,
                            help='Search term (default: %(default)s)')

        input_values = parser.parse_args()
        offset = random.random() * OFFSET_MULTIPLIER

        url_params = {
            'term': input_values.term.replace(' ', '+'),
            'latitude': args["latitude"],
            'longitude': args["longitude"],
            'radius': DEFAULT_RADIUS,
            'offset': int(offset),
            'limit': SEARCH_LIMIT
        }
        try:
            response = request(API_HOST, SEARCH_PATH, API_KEY, url_params=url_params)
            if response['businesses'] == []:
                offset = random.random() * response['total']
                url_params['offset'] = int(offset)
                response = request(API_HOST, SEARCH_PATH, API_KEY, url_params=url_params)
            return_args['activities'].append(response)
        except HTTPError as error:
            return_args['errors'].append(error)
    
    response['status'] = 200
    response['message'] = 'success'
    response['data'] = return_args
    return response

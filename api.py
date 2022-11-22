from __future__ import print_function

import argparse
import json
import pprint
import requests
import random
import sys
import urllib


try:
    # For Python 3.0 and later
    from urllib.error import HTTPError
    from urllib.parse import quote
    from urllib.parse import urlencode
except ImportError:
    # Fall back to Python 2's urllib2 and urllib
    from urllib.request import HTTPError
    from urllib import quote
    from urllib import urlencode


API_KEY="j_v7888BtpDfkf63L1k1i4eftbecVLmcaP1Dn85sQgqUsONNGn_rC9Lmkwk3r0jJg-Q2Btg-4em73jaWqJmQ5GoBXi72ErtURPYY2K7YZV494U0ir6QVZ6r1L6huY3Yx" 


# API constants, you shouldn't have to change these.
API_HOST = 'https://api.yelp.com'
SEARCH_PATH = '/v3/businesses/search'
BUSINESS_PATH = '/v3/businesses/'


DEFAULT_TERM = 'mountain hike'
DEFAULT_LOCATION = 'Burlington, VT'
SEARCH_LIMIT = 50
DEFAULT_RADIUS = 40000
OFFSET_MULTIPLIER = 1000


# Yelp API Example
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


def search(api_key, input_values, offset):
    """Query the Search API by a search term and location.
    Args:
        term (str): The search term passed to the API.
        location (str): The search location passed to the API.
    Returns:
        dict: The JSON response from the request.
    """

    url_params = {
        'term': input_values.term.replace(' ', '+'),
        'location': input_values.location.replace(' ', '+'),
        'radius': DEFAULT_RADIUS,
        'offset': offset,
        'limit': SEARCH_LIMIT
    }
    return request(API_HOST, SEARCH_PATH, api_key, url_params=url_params)


def get_business(api_key, business_id):
    """Query the Business API by a business ID.
    Args:
        business_id (str): The ID of the business to query.
    Returns:
        dict: The JSON response from the request.
    """
    business_path = BUSINESS_PATH + business_id

    return request(API_HOST, business_path, api_key)


def query_api(input_values):
    """Queries the API by the input values from the user.
    Args:
        term (str): The search term to query.
        location (str): The location of the business to query.
    """
    total = -100
    offset_multiplier = 0
    
    while total > 0 or total == -100:
        response = search(API_KEY, input_values, DEFAULT_OFFSET*offset_multiplier)

        try:
            if total == -100:
                total = response["total"]

            total -= SEARCH_LIMIT
            offset_multiplier += 1

            for business in response["businesses"]:
                # if business["rating"] == 5:
                print(business)
                print()
        except KeyError:
            break




def final_businesses(args):
    parser = argparse.ArgumentParser()
    return_args = {
        "activities": [],
    }

    for activity in args["activities"]:
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
            'radius': DEFAULT_RADIUS,
            'offset': offset,
            'limit': SEARCH_LIMIT
        }



def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-q', '--term', dest='term', default=DEFAULT_TERM,
                        type=str, help='Search term (default: %(default)s)')
    parser.add_argument('-l', '--location', dest='location',
                        default=DEFAULT_LOCATION, type=str,
                        help='Search location (default: %(default)s)')

    input_values = parser.parse_args()

    try:
        query_api(input_values)
    except HTTPError as error:
        sys.exit(
            'Encountered HTTP error {0} on {1}:\n {2}\nAbort program.'.format(
                error.code,
                error.url,
                error.read(),
            )
        )


if __name__ == '__main__':
    main()

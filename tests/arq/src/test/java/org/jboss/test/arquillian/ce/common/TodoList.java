/*
 * JBoss, Home of Professional Open Source
 * Copyright 2016 Red Hat Inc. and/or its affiliates and other
 * contributors as indicated by the @author tags. All rights reserved.
 * See the copyright.txt in the distribution for a full listing of
 * individual contributors.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

package org.jboss.test.arquillian.ce.common;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.jboss.arquillian.ce.httpclient.HttpClientBuilder;
import org.jboss.arquillian.ce.httpclient.HttpClientExecuteOptions;
import org.jboss.arquillian.ce.httpclient.HttpRequest;
import org.jboss.arquillian.ce.httpclient.HttpResponse;
import org.junit.Assert;

/**
 * @author Jonh Wendell
 */
public class TodoList {
    /**
     * Inserts an item in the todo example service. This method is a helper for
     * the full verson, and inserts a random summary and description.
     * 
     * @param url
     *            The url for the service
     * @throws Exception
     */
    public static void insertItem(String url) throws Exception {
        String summary = UUID.randomUUID().toString();
        String description = UUID.randomUUID().toString();
        insertItem(url, summary, description);
    }

    /**
     * Inserts an item in the todo example service.
     * 
     * @param url
     *            The url for the service
     * @param summary
     *            The summary to be inserted in the todo list
     * @param description
     *            The description of the item
     * @throws Exception
     */
    public static void insertItem(String url, String summary, String description) throws Exception {
        HttpRequest request = HttpClientBuilder.doPOST(url);

        Map<String, String> params = new HashMap<>();
        params.put("summary", summary);
        params.put("description", description);
        request.setEntity(params);

        final HttpClientExecuteOptions execOptions = new HttpClientExecuteOptions.Builder().tries(3)
                .desiredStatusCode(302).build();
        HttpResponse response = HttpClientBuilder.untrustedConnectionClient().execute(request, execOptions);

        Assert.assertEquals("Got an invalid response code. Body: " + response.getResponseBodyAsString(), 302,
                response.getResponseCode());
        Assert.assertTrue("Got an invalid 'Location' header: " + response.getHeader("Location"),
                response.getHeader("Location").endsWith("/index.html"));

        checkItem(url, summary, description);
    }

    /**
     * Checks if an item is present at the todo list.
     * 
     * @param url
     *            The url for the service
     * @param summary
     *            The summary to be checked
     * @param description
     *            The description to be checked
     * @throws Exception
     */
    public static void checkItem(String url, String summary, String description) throws Exception {
        HttpRequest request = HttpClientBuilder.doGET(url);
        final HttpClientExecuteOptions execOptions = new HttpClientExecuteOptions.Builder().tries(3)
                .desiredStatusCode(200).build();
        HttpResponse response = HttpClientBuilder.untrustedConnectionClient().execute(request, execOptions);
        String responseString = response.getResponseBodyAsString();

        Assert.assertEquals("Got an invalid response code. Body: " + responseString, 200, response.getResponseCode());

        /* TODO: Improve this check */
        Assert.assertTrue("Response: " + responseString + " - Summary: " + summary, responseString.contains(summary));
        Assert.assertTrue("Response: " + responseString + " - Description: " + description, responseString.contains(description));
    }
}
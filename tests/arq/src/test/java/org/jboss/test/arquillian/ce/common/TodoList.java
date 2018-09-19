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

import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.junit.Assert;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

import static io.restassured.RestAssured.get;
import static io.restassured.RestAssured.given;
import static io.restassured.RestAssured.post;
import static org.awaitility.Awaitility.await;

/**
 * @author Jonh Wendell
 */
public class TodoList {
    /**
     * Inserts an item in the todo example service. This method is a helper for
     * the full verson, and inserts a random summary and description.
     *
     * @param url The url for the service
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
     * @param url         The url for the service
     * @param summary     The summary to be inserted in the todo list
     * @param description The description of the item
     * @throws Exception
     */
    public static void insertItem(String url, String summary, String description) throws Exception {
        RestAssured.useRelaxedHTTPSValidation();

        Map<String, String> params = new HashMap<>();
        params.put("summary", summary);
        params.put("description", description);

        AtomicReference<Response> responseRef = new AtomicReference<>();

        await().atMost(20, TimeUnit.SECONDS).pollInterval(5, TimeUnit.SECONDS).until(() -> {
            try {
                Response r = given().formParams(params).post(url);

                if (r.getStatusCode() == 302) {
                    responseRef.set(r);
                    return true;
                }

                return false;
            } catch (Exception e) {
                return false;
            }
        });


        Response response = responseRef.get();

        if (response == null) {
            throw new Exception("Could not get response!");
        }

        Assert.assertEquals("Got an invalid response code. Body: " + response.print(), 302,
                response.getStatusCode());
        Assert.assertTrue("Got an invalid 'Location' header: " + response.header("Location"),
                response.header("Location").endsWith("/index.html"));

        checkItem(url, summary, description);
    }

    /**
     * Checks if an item is present at the todo list.
     *
     * @param url         The url for the service
     * @param summary     The summary to be checked
     * @param description The description to be checked
     * @throws Exception
     */
    public static void checkItem(String url, String summary, String description) throws Exception {
        RestAssured.useRelaxedHTTPSValidation();

        AtomicReference<Response> responseRef = new AtomicReference<>();

        await().atMost(20, TimeUnit.SECONDS).pollInterval(5, TimeUnit.SECONDS).until(() -> {
            try {
                Response r = get(url);

                if (r.getStatusCode() == 200) {
                    responseRef.set(r);
                    return true;
                }

                return false;
            } catch (Exception e) {
                return false;
            }
        });

        Response response = responseRef.get();

        if (response == null) {
            throw new Exception("Could not get response!");
        }

        String responseString = response.print();

        Assert.assertEquals("Got an invalid response code. Body: " + responseString, 200, response.getStatusCode());

        /* TODO: Improve this check */
        Assert.assertTrue("Response: " + responseString + " - Summary: " + summary, responseString.contains(summary));
        Assert.assertTrue("Response: " + responseString + " - Description: " + description, responseString.contains(description));
    }
}
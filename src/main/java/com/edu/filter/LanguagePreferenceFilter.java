package com.edu.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * Legacy filter retained for backward compatibility. Backend language handling
 * is now managed entirely on the client, so this filter simply forwards the
 * request without additional processing.
 */
@WebFilter("/*")
public class LanguagePreferenceFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
        // no-op
    }

    @Override
    public void doFilter(jakarta.servlet.ServletRequest servletRequest,
                         jakarta.servlet.ServletResponse servletResponse,
                         FilterChain chain) throws IOException, ServletException {
        chain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {
        // no-op
    }
}

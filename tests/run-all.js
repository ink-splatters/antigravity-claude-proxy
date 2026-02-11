#!/usr/bin/env bun
/**
 * Test Runner
 *
 * Runs all tests in sequence and reports results.
 * Usage: bun tests/run-all.js
 */
import path from 'node:path';

const tests = [
    { name: 'Account Selection Strategies', file: 'test-strategies.cjs' },
    { name: 'Fingerprint Management', file: 'test-fingerprint.cjs' },
    { name: 'Cache Control Stripping', file: 'test-cache-control.cjs' },
    { name: 'Thinking Signatures', file: 'test-thinking-signatures.cjs' },
    { name: 'Multi-turn Tools (Non-Streaming)', file: 'test-multiturn-thinking-tools.cjs' },
    { name: 'Multi-turn Tools (Streaming)', file: 'test-multiturn-thinking-tools-streaming.cjs' },
    { name: 'Interleaved Thinking', file: 'test-interleaved-thinking.cjs' },
    { name: 'Image Support', file: 'test-images.cjs' },
    { name: 'Prompt Caching', file: 'test-caching-streaming.cjs' },
    { name: 'Cross-Model Thinking', file: 'test-cross-model-thinking.cjs' },
    { name: 'OAuth No-Browser Mode', file: 'test-oauth-no-browser.cjs' },
    { name: 'Empty Response Retry', file: 'test-empty-response-retry.cjs' },
    { name: 'Schema Sanitizer', file: 'test-schema-sanitizer.cjs' },
    { name: 'Streaming Whitespace', file: 'test-streaming-whitespace.cjs' }
];

async function runTest(test) {
    const testPath = path.join(import.meta.dir, test.file);

    // Use Bun.spawn for native performance
    const proc = Bun.spawn(['bun', testPath], {
        stdin: 'inherit',
        stdout: 'inherit',
        stderr: 'inherit',
    });

    const exitCode = await proc.exited;
    return { ...test, passed: exitCode === 0 };
}

async function main() {
    console.log('╔══════════════════════════════════════════════════════════════╗');
    console.log('║              ANTIGRAVITY PROXY TEST SUITE                    ║');
    console.log('╚══════════════════════════════════════════════════════════════╝');
    console.log('');
    console.log('Make sure the server is running on port 8080 before running tests.');
    console.log('');

    // Check if running specific test
    const specificTest = process.argv[2];
    let testsToRun = tests;

    if (specificTest) {
        testsToRun = tests.filter(t =>
            t.file.includes(specificTest) || t.name.toLowerCase().includes(specificTest.toLowerCase())
        );
        if (testsToRun.length === 0) {
            console.log(`No test found matching: ${specificTest}`);
            console.log('\nAvailable tests:');
            tests.forEach(t => console.log(`  - ${t.name} (${t.file})`));
            process.exit(1);
        }
    }

    const results = [];

    for (const test of testsToRun) {
        console.log('\n');
        console.log('╔' + '═'.repeat(60) + '╗');
        console.log('║ Running: ' + test.name.padEnd(50) + '║');
        console.log('╚' + '═'.repeat(60) + '╝');
        console.log('');

        const result = await runTest(test);
        results.push(result);

        console.log('\n');
    }

    // Summary
    console.log('╔══════════════════════════════════════════════════════════════╗');
    console.log('║                      FINAL RESULTS                           ║');
    console.log('╠══════════════════════════════════════════════════════════════╣');

    let allPassed = true;
    for (const result of results) {
        const status = result.passed ? '✓ PASS' : '✗ FAIL';
        console.log(`║ ${status.padEnd(8)} ${result.name.padEnd(50)} ║`);
        if (!result.passed) allPassed = false;
    }

    console.log('╠══════════════════════════════════════════════════════════════╣');
    const overallStatus = allPassed ? '✓ ALL TESTS PASSED' : '✗ SOME TESTS FAILED';
    console.log(`║ ${overallStatus.padEnd(60)} ║`);
    console.log('╚══════════════════════════════════════════════════════════════╝');

    process.exit(allPassed ? 0 : 1);
}

main().catch(err => {
    console.error('Test runner failed:', err);
    process.exit(1);
});
